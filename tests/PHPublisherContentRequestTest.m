//
//  PHPublisherContentRequestTest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#import "SBJsonParser.h"
#import "NSObject+SBJSON.h"
#import "PHContent.h"
#import "PHContentView.h"
#import "PHPublisherContentRequest.h"
#import "PHStringUtil.h"

#define PUBLISHER_TOKEN @"PUBLISHER_TOKEN"
#define PUBLISHER_SECRET @"PUBLISHER_SECRET"
#define EXPECTED_HASH @"3L0xlrDOt02UrTDwMSnye05Awwk"

@interface PHContentTest : SenTestCase @end
@interface PHContentViewTest : SenTestCase @end
@interface PHContentViewRedirectTest : SenTestCase {
  PHContent *_content;
  PHContentView *_contentView;
  BOOL _didDismiss, _didLaunch;
}@end
@interface PHPublisherContentRequestTest : SenTestCase @end
@interface PHPublisherContentRewardsTest : SenTestCase @end

@implementation PHContentTest

-(void)testContent{
  NSString 
    *empty = @"{}",
    *keyword = @"{\"frame\":\"PH_FULLSCREEN\",\"url\":\"http://google.com\",\"transition\":\"PH_MODAL\",\"context\":{\"awesome\":\"awesome\"}}",
    *rect = @"{\"frame\":{\"PH_LANDSCAPE\":{\"x\":60,\"y\":40,\"w\":200,\"h\":400},\"PH_PORTRAIT\":{\"x\":40,\"y\":60,\"w\":240,\"h\":340}},\"url\":\"http://google.com\",\"transition\":\"PH_DIALOG\",\"context\":{\"awesome\":\"awesome\"}}";
  
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary
    *emptyDict = [parser objectWithString:empty],
    *keywordDict = [parser objectWithString:keyword],
    *rectDict = [parser objectWithString:rect];
  [parser release];
  
  PHContent *emptyUnit = [PHContent contentWithDictionary:emptyDict];
  STAssertNil(emptyUnit, @"Empty definition should result in nil!");
  
  PHContent *keywordUnit = [PHContent contentWithDictionary:keywordDict];
  STAssertNotNil(keywordUnit, @"Keyword definition should result in unit!");
  
  CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
  STAssertTrue(CGRectEqualToRect([keywordUnit frameForOrientation:UIInterfaceOrientationPortrait], applicationFrame),
               @"Frame mismatch from keyword. Got %@", NSStringFromCGRect(applicationFrame));
  
  NSURL *adURL = [NSURL URLWithString:@"http://google.com"];
  STAssertTrue([keywordUnit.URL isEqual:adURL],
               @"URL mismatch. Expected %@ got %@", adURL, keywordUnit.URL);
  
  STAssertTrue(keywordUnit.transition == PHContentTransitionModal,
               @"Transition type mismatched. Expected %d got %d", PHContentTransitionModal, keywordUnit.transition);
  
  STAssertNotNil([keywordUnit.context valueForKey:@"awesome"],
                 @"Expected payload key not found!");
  
  PHContent *rectUnit = [PHContent contentWithDictionary:rectDict];
  STAssertNotNil(rectUnit, @"Keyword definition should result in unit!");
  
  CGRect expectedLandscapeFrame = CGRectMake(60,40,200,400);
  STAssertTrue(CGRectEqualToRect([rectUnit frameForOrientation:UIInterfaceOrientationLandscapeLeft], expectedLandscapeFrame),
               @"Frame mismatch from keyword. Got %@", NSStringFromCGRect([rectUnit frameForOrientation:UIInterfaceOrientationLandscapeLeft]));
  
}

-(void)testCloseButtonDelayParameter{
  PHContent *content = [[PHContent alloc] init];
  STAssertTrue(content.closeButtonDelay == 10.0f, @"Default closeButton delay value incorrect!");
  [content release];
  
  NSString
  *rect = @"{\"frame\":{\"x\":60,\"y\":40,\"w\":200,\"h\":400},\"url\":\"http://google.com\",\"transition\":\"PH_DIALOG\",\"context\":{\"awesome\":\"awesome\"},\"close_delay\":23}";
  
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary *rectDict = [parser objectWithString:rect];
  [parser release];
  
  PHContent *rectUnit = [PHContent contentWithDictionary:rectDict];
  STAssertTrue(rectUnit.closeButtonDelay == 23.0f, @"Expected 23 got %f", content.closeButtonDelay);

}

-(void)testCloseButtonUrlParameter{
  PHContent *content = [[PHContent alloc] init];
  STAssertTrue(content.closeButtonURLPath == nil, @"CloseButtonURLPath property not available");
  [content release];
  
  NSString
  *rect = @"{\"frame\":{\"x\":60,\"y\":40,\"w\":200,\"h\":400},\"url\":\"http://google.com\",\"transition\":\"PH_DIALOG\",\"context\":{\"awesome\":\"awesome\"},\"close_ping\":\"http://playhaven.com\"}";
  
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary *rectDict = [parser objectWithString:rect];
  [parser release];
  
  PHContent *rectUnit = [PHContent contentWithDictionary:rectDict];
  STAssertTrue([rectUnit.closeButtonURLPath isEqualToString:@"http://playhaven.com"], @"Expected 'http://playhaven.com got %@", content.closeButtonURLPath);

}

@end

@implementation PHContentViewTest

-(void)testcontentView{
  PHContent *content = [[PHContent alloc] init];
  
  PHContentView *contentView = [[PHContentView alloc] initWithContent:content];
  STAssertTrue([contentView respondsToSelector:@selector(show:)],@"Should respond to show selector");
  STAssertTrue([contentView respondsToSelector:@selector(dismiss:)],@"Should respond to dismiss selector");
  [contentView release];
  [content release];
}

@end

@implementation PHContentViewRedirectTest

-(void)setUp{
  _content = [[PHContent alloc] init];
  
  _contentView = [[PHContentView alloc] initWithContent:_content];
  [_contentView redirectRequest:@"ph://dismiss" toTarget:self action:@selector(dismissRequestCallback:)];
  [_contentView redirectRequest:@"ph://launch" toTarget:self action:@selector(launchRequestCallback:)];
}

-(void)testRegularRequest{
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
  BOOL result = [_contentView webView:nil shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeLinkClicked];
  STAssertTrue(result, @"_contentView should open http://google.com in webview!");
}

-(void)testDismissRequest{
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"ph://dismiss"]];
  BOOL result = [_contentView webView:nil shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeLinkClicked];
  STAssertFalse(result, @"_contentView should not open ph://dismiss in webview!");
}

-(void)dismissRequestCallback:(NSDictionary *)parameters{
  STAssertNil(parameters, @"request with no parameters returned parameters!");
}
   
-(void)testLaunchRequest{
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"ph://launch?context=%7B%22url%22%3A%22http%3A%2F%2Fadidas.com%22%7D"]];  
  BOOL result = [_contentView webView:nil shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeLinkClicked];
  STAssertFalse(result, @"_contentView should not open ph://dismiss in webview!");
}

-(void)launchRequestCallback:(NSDictionary *)parameters{
  STAssertNotNil(parameters, @"request with parameters returned no parameters!");
  STAssertTrue([@"http://adidas.com" isEqualToString:[parameters valueForKey:@"url"]], 
               @"Expected 'http://adidas.com' got %@ as %@", 
               [parameters valueForKey:@"url"], [[parameters valueForKey:@"url"] class]);

}

-(void)dealloc{
  [_content release], _content = nil;
  [_contentView release], _contentView = nil;
  [super dealloc];
}

@end

@implementation PHPublisherContentRequestTest

-(void)testAnimatedParameter{
  PHPublisherContentRequest *request = [PHPublisherContentRequest requestForApp:PUBLISHER_TOKEN secret:PUBLISHER_SECRET];
  STAssertTrue(request.animated, @"Default state of animated property should be TRUE");
  
  request.animated = NO;
  STAssertFalse(request.animated, @"Animated property not set!");
}

-(void)testRequestParameters{
    PHPublisherContentRequest *request = [PHPublisherContentRequest requestForApp:PUBLISHER_TOKEN secret:PUBLISHER_SECRET];
    request.placement = @"placement_id";
    
    NSDictionary *dictionary = [request signedParameters];
    STAssertNotNil([dictionary valueForKey:@"placement_id"], @"Expected 'placement_id' parameter.");
    
    NSString *parameterString = [request signedParameterString];
    NSString *placementParam = @"placement_id=placement_id";
    STAssertFalse([parameterString rangeOfString:placementParam].location == NSNotFound,
                  @"Placment_id parameter not present!");
    
}

@end

@implementation PHPublisherContentRewardsTest

-(void)testValidation{
  NSString *reward = @"SLAPPY_COINS";
  NSNumber *quantity = [NSNumber numberWithInt:1234];
  NSNumber *receipt = [NSNumber numberWithInt:102930193];
  NSString *signature = [PHStringUtil hexDigestForString:[NSString stringWithFormat:@"%@:%@:%@:%@:%@",
                         reward, quantity, [[UIDevice currentDevice] uniqueIdentifier], receipt, PUBLISHER_SECRET]];
  
  NSDictionary *rewardDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              reward, @"reward",
                              quantity, @"quantity",
                              receipt, @"receipt",
                              signature, @"signature",
                              nil];
  NSDictionary *badRewardDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 reward, @"reward",
                                 quantity, @"quantity",
                                 receipt, @"receipt",
                                 @"BAD_SIGNATURE_RARARA", @"signature",
                                 nil];
  
  PHPublisherContentRequest *request = [PHPublisherContentRequest requestForApp:PUBLISHER_TOKEN secret:PUBLISHER_SECRET];
  
  STAssertTrue([request isValidReward:rewardDict], @"PHPublisherContentRequest could not validate valid reward.");
  STAssertFalse([request isValidReward:badRewardDict], @"PHPublisherContentRequest validated invalid reward.");
}

@end
