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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"true", @"new_device", 
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

- (NSDictionary*)signedParameters {
    //we override to cleanup parameters we don't need
    NSMutableDictionary *signedParameters = [[super signedParameters] mutableCopy];
    
#warning Debug hack to create hash from device instead of new gid for legacy api
    NSString 
    *device = [[UIDevice currentDevice] uniqueIdentifier],
    *nonce = [PHStringUtil uuid],
    *signatureHash = [NSString stringWithFormat:@"%@:%@:%@:%@", self.token, device, nonce, self.secret];
    
    signatureHash = [PHPublisherOpenRequest base64SignatureWithString:signatureHash];
    [signedParameters setObject:signatureHash forKey:@"signature"];
    
    return [signedParameters autorelease];
    
}
- (NSString*)urlPath {
    return [PH_URL(/v3/advertiser/open/) stringByReplacingOccurrencesOfString:@"2" withString:@""];
}

- (void)dealloc {
    [_game_token release], _game_token = nil;
    [super dealloc];
}
@end
