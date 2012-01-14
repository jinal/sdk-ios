//
//  PHPublisherIAPTrackingRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 1/13/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "PHAPIRequest.h"
#import "PHPurchase.h"

@interface PHPublisherIAPTrackingRequest : PHAPIRequest<SKProductsRequestDelegate>{
    NSString *_product;
    NSInteger _quantity;
    SKProduct *_productInfo;
    PHPurchaseResolutionType _resolution;
}

+(void)setConversionCookie:(NSString *)cookie forProduct:(NSString *)product;
+(NSString *)getConversionCookieForProduct:(NSString *)product;

@property (nonatomic, copy) NSString *product;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) PHPurchaseResolutionType resolution;

@end
