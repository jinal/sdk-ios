//
//  PHReward.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 7/11/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHReward.h"

@implementation PHReward

@synthesize name = _reward;
@synthesize quantity = _quanity;
@synthesize receipt = _receipt;

-(void)dealloc{
    [_reward release], _reward = nil;
    [_receipt release], _receipt = nil;
    
    [super dealloc];
}

@end
