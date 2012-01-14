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

+(NSString *)stringForResolution:(PHPurchaseResolutionType)resolution{
    NSString *result = @"error";
    switch (resolution) {
        case PHPurchaseResolutionBuy:
            result = @"buy";
            break;
            
        case PHPurchaseResolutionCancel:
            result = @"cancel";
            break;
            
        default:
            result = @"error";
            break;
    }
    
    return result;
}

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

-(void) reportResolution:(PHPurchaseResolutionType)resolution{
    
    NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:
                              [PHPurchase stringForResolution:resolution],@"resolution", nil];
    NSDictionary *callbackDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.callback, @"callback",
                                        response, @"response", nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:PHCONTENTVIEW_CALLBACK_NOTIFICATION object:callbackDictionary]; 
}

@end
