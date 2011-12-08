//
//  PHConstants.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 9/13/11.
//  Copyright 2011 Playhaven. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "PHConstants.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

#if ! defined(IFT_ETHER)
#define IFT_ETHER 0x6/* Ethernet CSMACD */
#endif


NSError *PHCreateError(PHErrorType errorType){
  static NSArray *errorArray;
  if (errorArray == nil) {
    errorArray = [[NSArray alloc] initWithObjects:
                  @"PlayHaven received an error response from the API. Please check your token and secret values and try again.",
                  @"Response was successful, but did not contain a response object.",
                  @"The content you requested was not able to be shown because it is missing required orientation data.",
                  @"The content you requested has been dismissed because PlayHaven was not able to load content data.",
                  @"PlayHaven was not able to create the content unit overlay",
                  nil];
  }
  
  NSString *errorMessage = [errorArray objectAtIndex:errorType];
  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                            errorMessage, NSLocalizedDescriptionKey,
                            nil];
  
  return [NSError errorWithDomain:@"PlayHavenSDK" code:(NSInteger)errorType userInfo:userInfo];
}

/*
 * getWiFiIPAddress code courtesy of Matt Brown
 * http://mattbsoftware.blogspot.com/2009/04/how-to-get-ip-address-of-iphone-os-v221.html
 */
NSString *_getWiFiIPAddress(){
  
  BOOL success;
  struct ifaddrs * addrs;
  const struct ifaddrs * cursor;
  
  success = getifaddrs(&addrs) == 0;
  if (success) {
    cursor = addrs;
    while (cursor != NULL) {
      if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0){ // this second test keeps from picking up the loopback address
        NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
        if ([name isEqualToString:@"en0"] || [name isEqualToString:@"en1"]) { // found the WiFi adapter
          return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
        }
      }
      
      cursor = cursor->ifa_next;
    }
    freeifaddrs(addrs);
  }
  return NULL;
}

/*
 * Network status code courtesy of unforgiven on Stack Overflow
 * http://stackoverflow.com/questions/1448411/how-to-check-for-local-wi-fi-not-just-cellular-connection-using-iphone-sdk/1480867#1480867
 */

int PHNetworkStatus(){
  //TODO: change this to check API accessibility specifically
	struct sockaddr_in zeroAddr;
	bzero(&zeroAddr, sizeof(zeroAddr));
	zeroAddr.sin_len = sizeof(zeroAddr);
	zeroAddr.sin_family = AF_INET;
  
	SCNetworkReachabilityRef target = 
  SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddr);
  
  SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(target, &flags);
  
  BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
  BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
  
  if(isReachable && !needsConnection) // connection is available 
  {
    
    // determine what type of connection is available
    BOOL isCellularConnection = ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0);
    NSString *wifiIPAddress = _getWiFiIPAddress();
    
    if(isCellularConnection) 
      return 1; // cellular connection available
    
    if(wifiIPAddress)
      return 2; // wifi connection available
  }
    
  return 0; // no connection at all
}