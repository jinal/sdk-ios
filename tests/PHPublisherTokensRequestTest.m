//
//  PHPublisherPromosRequestTest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/20/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "PHAPIRequest.h"
#import "PHPublisherPromosRequest.h"
#import "JSON.h"

#define PUBLISHER_TOKEN @"PUBLISHER_TOKEN"
#define PUBLISHER_SECRET @"PUBLISHER_SECRET"

@interface PHPublisherPromosRequestTest: SenTestCase<PHAPIRequestDelegate>{
  PHPublisherPromosRequest *_request;
  BOOL _didHandleRequest;
}
@end

@implementation PHPublisherPromosRequestTest

-(void)setUp{
  _didHandleRequest = NO;
  _request = [[PHPublisherPromosRequest alloc] initWithApp:PUBLISHER_TOKEN secret:PUBLISHER_SECRET delegate:self];
}

-(void)testRequestProcessing{
  NSString *responseData = @"{\"response\":{\"redeemed\":[\"TOKEN_0\",\"TOKEN_1\"]}}";
  SBJsonParser *parser = [SBJsonParser new];
  NSDictionary *responseDictionary = [parser objectWithString:responseData];
  [parser release];
  
  [_request processRequestResponse:responseDictionary];
}

-(void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData{
    _didHandleRequest = YES;
  NSArray *redeemedTokens = [responseData valueForKey:@"redeemed"];
  STAssertTrue([redeemedTokens isKindOfClass:[NSArray class]], @"Redeemed tokens array not an array!");
  STAssertTrue([redeemedTokens containsObject:@"TOKEN_0"], @"Redeemed tokens does not contain expected value!");
}

-(void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error{
  STFail(@"Was not expecting an error!");
}

-(void)tearDown{
  STAssertTrue(_didHandleRequest, @"Did not actually handle request!");
  [_request release], _request = nil;
}


@end
