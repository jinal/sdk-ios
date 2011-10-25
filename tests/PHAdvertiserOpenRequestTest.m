//
//  PHAdvertiserOpenRequestTest.m
//  playhaven-sdk-ios
//
//  Created by Sam Stewart on 10/17/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "PHAdvertiserOpenRequest.h"
#import <UIKit/UIKit.h>

@interface PHAdvertiserOpenRequestTest : SenTestCase
@end

@implementation PHAdvertiserOpenRequestTest

- (void)testInstance {
    NSString *token = @"PUBLISHER_TOKEN",
             *secret = @"PUBLISHER_SECRET";
    
    PHAdvertiserOpenRequest *request = [[PHAdvertiserOpenRequest alloc] initWithApp:token secret:secret];
    NSString *requestURL = [request.URL absoluteString];
    
    STAssertNotNil(requestURL, @"Paramater string is nil?");
    STAssertFalse([requestURL rangeOfString:@"advertiser_token="].location == NSNotFound, @"Advertiser token not present!");
    STAssertFalse([requestURL rangeOfString:@"new_device="].location == NSNotFound, @"New device not present!");
    
}

@end
