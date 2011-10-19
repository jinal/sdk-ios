//
//  PHPublisherOpenRequest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHPublisherOpenRequest.h"
#import "PHConstants.h"
#import "PHStringUtil.h"

#define PASTEBOARD_NAME @"com.playhaven.ios.sdk.phid"

@implementation PHPublisherOpenRequest
@dynamic phid;

#pragma mark PHID Management
- (NSString*)phid {
    if (!_phid) {
        UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:PASTEBOARD_NAME create:YES];
        pasteboard.persistent = YES;
        NSString *saved_id = pasteboard.string;
        
        self.phid = saved_id;
        
        return saved_id;
    }
    return _phid;
}
- (void)setPhid:(NSString*)phid {
    if (_phid && _phid != phid) [_phid release], _phid = nil;

    _phid = [phid retain];
}

#pragma mark PHAPIRequest Override
-(NSString *)urlPath{
    return PH_URL(/v3/publisher/open/);
}

-(NSDictionary*)additionalParameters {
    return (self.phid ? [NSDictionary dictionaryWithObjectsAndKeys:self.phid, @"phid", nil] : nil);
}


-(void)processRequestResponse:(NSDictionary *)responseData{
    NSDictionary *response = [responseData objectForKey:@"response"];
    NSString *phid = [response objectForKey:@"phid"];
    
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:PASTEBOARD_NAME create:YES];
    pasteboard.persistent = YES;
    pasteboard.string = phid;
    self.phid = phid;
    
    [self didSucceedWithResponse:nil];
}

-(void)dealloc {
    [super dealloc];
    [_phid release];
}
@end
