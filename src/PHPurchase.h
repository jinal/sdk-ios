//
//  PHPurchase.h
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/12/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    PHPurchasedCancel,
    PHPurchased
} PHPurchaseResolutionType;

@interface PHPurchase : NSObject{

    NSString *_productIdentifier;
    NSString *_item;
    NSInteger _quanity;
    NSString *_receipt;
    NSDictionary *_callback;
}

@property (nonatomic, copy) NSString *productIdentifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, copy) NSString *receipt;
@property (nonatomic, copy) NSDictionary *callback;

//
// Called by the Publisher to share the results of the IAP with Play Haven dashboard
//
-(void) reportResolutuion:(PHPurchase *)purchase resolution:(PHPurchaseResolutionType)res;

@end
