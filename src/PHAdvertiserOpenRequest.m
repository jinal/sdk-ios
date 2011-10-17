//
//  PHAdvertiserOpenRequest.m
//  playhaven-sdk-ios
//
//  Created by Sam Stewart on 10/17/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHAdvertiserOpenRequest.h"
#import "PHConstants.h"

@implementation PHAdvertiserOpenRequest
@synthesize game_token=_game_token;

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
    return [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"new_device", 
            self.game_token, @"advertiser_token", nil];
}

- (NSDictionary*)signedParameters {
    //we override to cleanup parameters we don't need
    NSMutableDictionary *signedParameters = [[super signedParameters] mutableCopy];
    
    [signedParameters removeObjectForKey:@"app_version"];
    [signedParameters removeObjectForKey:@"app"];
    [signedParameters removeObjectForKey:@"hardware"];
    //[signedParameters removeObjectForKey:@"nonce"];
    [signedParameters removeObjectForKey:@"os"];
    [signedParameters removeObjectForKey:@"idiom"];
    
    return [signedParameters autorelease];
    
}
- (NSString*)urlPath {
    return PH_URL(/v3/advertiser/open/);
}

- (void)dealloc {
    [_game_token release], _game_token = nil;
    [super dealloc];
}
@end
