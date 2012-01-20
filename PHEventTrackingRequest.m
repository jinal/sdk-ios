//
//  PHEventTrackingRequest.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHEventTrackingRequest.h"
#import "PHConstants.h"

@interface PHEventTrackingRequest(Private)

@end


// NOTE: have a send event records and a send all option


@implementation PHEventTrackingRequest

-(void)dealloc{
    //[_product release], _product = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark PHAPIRequest

-(NSString *)urlPath{
    return PH_URL(/v3/publisher/tracking/);
}

-(NSDictionary *)additionalParameters{
    return nil;
    /*
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.product, @"product",
            [NSNumber numberWithInteger: self.quantity], @"quantity",
            [PHPurchase stringForResolution:self.resolution], @"resolution",
            _productInfo.price, @"price",
            _productInfo.priceLocale, @"price_locale", 
            [PHPublisherIAPTrackingRequest getConversionCookieForProduct:self.product], @"cookie", nil];
    */
}

-(void)send{
    /*
    NSSet *productSet = [NSSet setWithObject:self.product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
    [request setDelegate:self];
    [request start];
    */
}

#pragma mark - PHAPIRequest response delegate

-(void)didSucceedWithResponse:(NSDictionary *)responseData{

    // If successful clean up the event cache or event records that was sent to the server.

    if ([self.delegate respondsToSelector:@selector(request:didSucceedWithResponse:)]) {
        [self.delegate performSelector:@selector(request:didSucceedWithResponse:) withObject:self withObject:responseData];
    }
}


@end
