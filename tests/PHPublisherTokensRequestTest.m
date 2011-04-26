//
//  PHPublisherTokensRequestTest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/20/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "PHAPIRequest.h"
#import "PHPublisherTokensRequest.h"
#import "NSString+SBJSON.h"

#define PUBLISHER_TOKEN @"PUBLISHER_TOKEN"
#define PUBLISHER_SECRET @"PUBLISHER_SECRET"

@interface PHPublisherTokensRequestTest: SenTestCase<PHAPIRequestDelegate>{
  PHPublisherTokensRequest *_request;
  BOOL _didHandleRequest;
}
@end

@implementation PHPublisherTokensRequestTest

-(void)setUp{
  _didHandleRequest = NO;
  _request = [[PHPublisherTokensRequest alloc] initWithApp:PUBLISHER_TOKEN secret:PUBLISHER_SECRET delegate:self];
}

-(void)testRequestProcessing{
  NSString *responseData = @"{\"response\":{\"redeemed\":[\"TOKEN_0\",\"TOKEN_1\"]}}";
  [_request processRequestResponse:[responseData JSONValue]];
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
