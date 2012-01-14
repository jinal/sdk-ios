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

typedef enum{
    PHPublisherIAPTrackingResolutionPurchased,
    PHPublisherIAPTrackingResolutionCanceled,
    PHPublisherIAPTrackingResolutionError
} PHPublisherIAPTrackingResolution

@interface PHPublisherIAPTrackingRequest : PHAPIRequest<SKProductsRequestDelegate>{
    NSString *_product;
    NSInteger _quantity;
    SKProduct *_productInfo;
    PHPublisherIAPTrackingResolution _resolution;
}

+(NSString *)stringForResolution: (PHPublisherIAPTrackingResolution) resolution;
+(void)setConversionCookie:(NSString *)cookie forProduct:(NSString *)product;
+(NSString *)getConversionCookieForProduct:(NSString *)product;

@property (nonatomic, retain) NSString *product;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) PHPublisherIAPTrackingResolution resolution;

@end
