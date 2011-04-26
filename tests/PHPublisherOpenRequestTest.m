//
//  PHPublisherOpenRequestTest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "PHPublisherOpenRequest.h"

#define EXPECTED_HASH @"3L0xlrDOt02UrTDwMSnye05Awwk"
//#define EXPECTED_HASH @"sbiA9ROvCFEPANNFLbq3BK6m_dU-"

@interface PHPublisherOpenRequestTest : SenTestCase
@end


@implementation PHPublisherOpenRequestTest

-(void)testInstance{
  NSString *token = @"PUBLISHER_TOKEN", 
           *secret = @"PUBLISHER_SECRET";
  PHPublisherOpenRequest *request = [PHPublisherOpenRequest requestForApp:(NSString *)token secret:(NSString *)secret];
  NSString *requestURLString = [request.URL absoluteString];
  
  STAssertNotNil(requestURLString, @"Parameter string is nil?");
  STAssertFalse([requestURLString rangeOfString:@"device="].location == NSNotFound,
                @"Device parameter not present!");
  STAssertFalse([requestURLString rangeOfString:@"token="].location == NSNotFound,
                @"Token parameter not present!");
  STAssertFalse([requestURLString rangeOfString:@"nonce="].location == NSNotFound,
                @"Nonce parameter not present!");
  STAssertFalse([requestURLString rangeOfString:@"signature="].location == NSNotFound,
                @"Secret parameter not present!");
  
  STAssertTrue([request respondsToSelector:@selector(send)], @"Send method not implemented!");
}

@end
