//
//  PHPurchase.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/12/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHPurchase.h"

@implementation PHPurchase

@synthesize productIdentifier = _productIdentifier;
@synthesize name = _item;
@synthesize quantity = _quanity;
@synthesize receipt = _receipt;

-(void)dealloc{
    [_productIdentifier release], _productIdentifier = nil;
    [_item release], _item = nil;
    [_receipt release], _receipt = nil;
    
    [super dealloc];
}

@end
