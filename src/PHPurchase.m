//
//  PHPurchase.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/12/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHPurchase.h"
#import "PHConstants.h"

@implementation PHPurchase

@synthesize productIdentifier = _productIdentifier;
@synthesize name = _item;
@synthesize quantity = _quanity;
@synthesize receipt = _receipt;
@synthesize callback = _callback;

-(void)dealloc{
    [_productIdentifier release], _productIdentifier = nil;
    [_item release], _item = nil;
    [_receipt release], _receipt = nil;
    [_callback release], _callback = nil;
    
    [super dealloc];
}

-(void) reportResolutuion:(PHPurchase *)purchase resolution:(PHPurchaseResolutionType)res{

    if (res == PHPurchasedCancel)
        [_callback setValue:@"purchaseCanceled" forKey:@"response"];
    else
        [_callback setValue:@"purchasePurchased" forKey:@"response"];

    [[NSNotificationCenter defaultCenter] postNotificationName:PHCONTENTVIEW_CALLBACK_NOTIFICATION object:self]; 
}

@end
