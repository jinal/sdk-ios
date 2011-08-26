//
//  PHURLLoader.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 2/9/11.
//  Copyright 2011 Playhaven. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PHURLLoader.h"
#define MAXIMUM_REDIRECTS 10

@interface PHURLLoader(Private)
-(void)finish;
-(void)fail;
@end

@implementation PHURLLoader

@synthesize delegate = _delegate;
@synthesize targetURL = _targetURL;
@synthesize opensFinalURLOnDevice = _opensFinalURLOnDevice;
@synthesize context = _context;

#pragma mark -
#pragma mark Static

+(PHURLLoader *) openDeviceURL:(NSString *)url{
  PHURLLoader *result = [[[PHURLLoader alloc] init] autorelease];
  result.targetURL = [NSURL URLWithString:url];
  [result open];
  
  return result;
}


#pragma mark -
#pragma mark Instance
-(id)init{
  if ((self = [super init])) {
    _opensFinalURLOnDevice = YES;
  }
  
  return self;
}

-(void) dealloc{
  [_targetURL release], _targetURL = nil;
  
  [_connection cancel];
  [_connection release], _connection = nil;
  [_context release], _context = nil;
  
  [super dealloc];
}

#pragma mark -
#pragma mark PHURLLoader
-(void) open{
  if (!!self.targetURL) {
    NSLog(@"PHURLLoader: opening url %@", self.targetURL);
    _totalRedirects = 0;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.targetURL];
    
    [_connection cancel];
    [_connection release], _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

    //PHURLLOADER_RETAIN see PHURLLOADER_RELEASE
    [self retain];
  }
}

-(void)finish{
  if ([self.delegate respondsToSelector:@selector(loaderFinished:)]) {
    [self.delegate loaderFinished:self];
  }
  
  //PHURLLOADER_RELEASE see PHURLLOADER_RETAIN
  [self release];
  
  if (self.opensFinalURLOnDevice) {
    //actually open in app at this point
    [[UIApplication sharedApplication] openURL:self.targetURL];
  }
}

-(void)fail{
  if ([self.delegate respondsToSelector:@selector(loaderFailed:)]) {
    [self.delegate loaderFailed:self];
  }
  
  //PHURLLOADER_RELEASE see PHURLLOADER_RETAIN
  [self release];
}


#pragma mark -
#pragma mark NSURLConnection
-(NSURLRequest *) connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
  NSLog(@"PHURLLoader: processing redirect");
  self.targetURL = [request URL];
  if (++_totalRedirects < MAXIMUM_REDIRECTS) {
    return request;
  } else {
    NSLog(@"PHURLLoader: max redirects with URL %@", self.targetURL);
    [self finish];
    
    [connection cancel];
    return nil;
  }
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
  NSLog(@"PHURLLoader: failing with error: %@", [error localizedDescription]);
  [self fail];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  NSLog(@"PHURLLoader: did recieve response with code: %d", [httpResponse statusCode]);
  if ([httpResponse statusCode] < 300) {
    NSLog(@"PHURLLoader: finishing with URL %@", self.targetURL);
    [self finish];
  } else {
    NSLog(@"PHURLLoader: failing with URL %@", self.targetURL);
    [self fail];
  }
  
  //we don't need the rest of this connection anymore;
  [connection cancel];
}

@end
