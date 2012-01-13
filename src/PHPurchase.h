//
//  PHPurchase.h
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/12/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHPurchase : NSObject{

    NSString *_productIdentifier;
    NSString *_item;
    NSInteger _quanity;
    NSString *_receipt;
}

@property (nonatomic, copy) NSString *productIdentifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, copy) NSString *receipt;

@end
