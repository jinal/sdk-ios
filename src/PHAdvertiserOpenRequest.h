//
//  PHAdvertiserOpenRequest.h
//  playhaven-sdk-ios
//
//  Created by Sam Stewart on 10/17/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHAPIRequest.h"

@interface PHAdvertiserOpenRequest : PHAPIRequest


+ (id)requestForApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate;

- (id)initWithApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate;

@property (nonatomic, retain) NSString *game_token;
@end
