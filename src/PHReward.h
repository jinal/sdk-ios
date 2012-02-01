//
//  PHReward.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 7/11/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHReward : NSObject{
    NSString *_reward;
    NSInteger _quanity;
    NSString *_receipt;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, copy) NSString *receipt;

@end
