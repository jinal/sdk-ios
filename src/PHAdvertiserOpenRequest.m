//
//  PHAdvertiserOpenRequest.m
//  playhaven-sdk-ios
//
//  Created by Sam Stewart on 10/17/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHAdvertiserOpenRequest.h"
#import "PHConstants.h"
#import "PHStringUtil.h"

@implementation PHAdvertiserOpenRequest
@synthesize isNewDevice = _isNewDevice;

#pragma mark PHAPIRequest
- (NSDictionary*)additionalParameters {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            (self.isNewDevice ? @"1" : @"0"), @"new_device", 
                            self.token, @"advertiser_token", 
                            [PHStringUtil phid], @"phid",
                            nil];
    return params;
}

-(void)didSucceedWithResponse:(NSDictionary *)responseData{
    [PHStringUtil setPhid:[responseData valueForKey:@"phid"]];
    [super didSucceedWithResponse:responseData]; 
}

- (NSString*)urlPath {
#ifdef PH_USE_OLD_ADVERTISER_API
    return [PH_URL(/v3/advertiser/open/) stringByReplacingOccurrencesOfString:@"2" withString:@""];
#else
    return PH_URL(/v3/advertiser/open/);
#endif
}

- (void)dealloc {
    [super dealloc];
}
@end
