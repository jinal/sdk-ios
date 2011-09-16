//
//  PHConstants.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 9/13/11.
//  Copyright 2011 Playhaven. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PHConstants.h"

NSError *PHCreateError(PHErrorType errorType){
  static NSArray *errorArray;
  if (errorArray == nil) {
    errorArray = [[NSArray alloc] initWithObjects:
                  @"PlayHaven received an error response from the API. Please check your token and secret values and try again.",
                  @"Response was successful, but did not contain a response object.",
                  @"The content you requested was not able to be shown because it is missing required orientation data.",
                  @"The content you requested has been dismissed because PlayHaven was not able to load content data.",
                  nil];
  }
  
  NSString *errorMessage = [errorArray objectAtIndex:errorType];
  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                            errorMessage, NSLocalizedDescriptionKey,
                            nil];
  
  return [NSError errorWithDomain:@"PlayHavenSDK" code:(NSInteger)errorType userInfo:userInfo];
}