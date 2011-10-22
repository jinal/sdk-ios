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
#import "PHPublisherOpenRequest.h"

#define PH_USE_OLD_ADVERTISER_API 0

//change PH_URL to old api..
#ifdef PH_USE_OLD_ADVERTISER_API
#undef PH_URL
#define PH_URL(PATH) [[PH_BASE_URL  stringByReplacingOccurrencesOfString:@"2" withString:@""] stringByAppendingString:@#PATH] 
#endif

@implementation PHAdvertiserOpenRequest
@synthesize game_token=_game_token, new_device;

+ (id)requestForApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate {
    return [[[self class] alloc] initWithApp:token secret:secret];
}
- (id)initWithApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate {
    if ((self = [super initWithApp:token secret:secret])) {
        self.delegate = delegate;
    }
    
    return self;
}

#pragma mark Override Methods
- (NSDictionary*)additionalParameters {
    //Request Required Params: device, token, signature, advertiser_token, new_device
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   (self.new_device ? @"1" : @"0"), @"new_device", 
                                   self.game_token, @"advertiser_token", nil];
    
    if ([PHStringUtil phid]) [params setObject:[PHStringUtil phid] forKey:@"phid"];
    
    return params;
}

-(void)processRequestResponse:(NSDictionary *)responseData{
    NSDictionary *response = [responseData objectForKey:@"response"];
    NSString *phid = [response objectForKey:@"phid"];
    
    [PHStringUtil setPhid:phid];
    
    [self didSucceedWithResponse:nil];
}

- (NSString*)urlPath {
    return PH_URL(/v3/advertiser/open/);
}

- (void)dealloc {
    [_game_token release], _game_token = nil;
    [super dealloc];
}
@end
