//
//  AdvertiserOpenController.m
//  playhaven-sdk-ios
//
//  Created by Sam Stewart on 10/17/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "AdvertiserOpenController.h"

@implementation AdvertiserOpenController

#pragma mark Override Methods
- (void)startRequest {
    [super startRequest];
    
    PHAdvertiserOpenRequest *request = [[PHAdvertiserOpenRequest alloc] initWithApp:self.token secret:self.secret];
    request.delegate = self;
    
    [request send];
}

#pragma mark PHAPIRequest Delegate
- (void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error {
    NSString *message = [NSString stringWithFormat:@"✖ Failed with error: %@", error];
    [self addMessage:message];
}
- (void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData {
    NSString *message = [NSString stringWithFormat:@"✔ Success with response: %@",responseData];
    [self addMessage:message];
}
@end
