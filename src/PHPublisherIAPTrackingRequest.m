//
//  PHPublisherIAPTrackingRequest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 1/13/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "PHPublisherIAPTrackingRequest.h"
#import "PHConstants.h"

@interface PHPublisherIAPTrackingRequest(Private)
+(NSMutableDictionary *)allConversionCookies;
@end

@implementation PHPublisherIAPTrackingRequest

+(NSMutableDictionary *)allConversionCookies{
    static NSMutableDictionary *conversionCookies;
    if (conversionCookies == nil) {
        conversionCookies = [[NSMutableDictionary alloc] init];
    }
    
    return conversionCookies;
}

+(void)setConversionCookie:(NSString *)cookie forProduct:(NSString *)product{
    [[self allConversionCookies] setValue:cookie forKey:product];
}

+(NSString *)getConversionCookieForProduct:(NSString *)product{
    NSString *result = [[self allConversionCookies] valueForKey:product];
    [[self allConversionCookies] setValue:nil forKey:product];
    return result;
}

@synthesize product;
@synthesize quantity;
@synthesize resolution;
@synthesize skError;

-(void)dealloc{
    [_product release], _product = nil;
    [_productInfo release], _productInfo = nil;
    [_skError release], _skError = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark PHAPIRequest

-(NSString *)urlPath{
    return PH_URL(/v3/publisher/iap/);
}

-(NSDictionary *)additionalParameters{
    if (_skError == nil)
        return [NSDictionary dictionaryWithObjectsAndKeys:
                self.product, @"product",
                [NSNumber numberWithInteger: self.quantity], @"quantity",
                [PHPurchase stringForResolution:self.resolution], @"resolution",
                @"ios", @"store", 
                _productInfo.price, @"price",
                _productInfo.priceLocale, @"price_locale", 
                [PHPublisherIAPTrackingRequest getConversionCookieForProduct:self.product], @"cookie", nil];
    else
        return [NSDictionary dictionaryWithObjectsAndKeys:
                self.product, @"product",
                [NSNumber numberWithInteger: self.quantity], @"quantity",
                [PHPurchase stringForResolution:self.resolution], @"resolution",
                @"ios", @"store", 
                [NSNumber numberWithInteger: _skError.code], @"error_code",
                [PHPublisherIAPTrackingRequest getConversionCookieForProduct:self.product], @"cookie", nil];
}

-(void)send{
    NSSet *productSet = [NSSet setWithObject:self.product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
    [request setDelegate:self];
    [request start];
}

#pragma mark -
#pragma mark SKProductsRequestDelegate
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    if ([response.products count] > 0) {
        SKProduct *productInfo = [response.products objectAtIndex:0];
        [_productInfo release], _productInfo = [productInfo retain];
    }

    [super send];
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{

    [super send];
}

@end

