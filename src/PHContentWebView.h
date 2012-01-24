//
//  PHContentWebView.h (formerly PHAdUnitWebView.h)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/6/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef PH_UNIT_TESTING
@interface PHContentWebView : UIWebView {
#else
@interface PHContentWebView : UIView {
#endif
    SEL _action;
    id _target;
    BOOL _isAnimating;
}

@property (nonatomic, readonly) BOOL isAnimating;
    
-(void)bounceInWithTarget:(id)target action:(SEL)action;
-(void)bounceOutWithTarget:(id)target action:(SEL)action;

#ifdef PH_UNIT_TESTING
@property (nonatomic, assign) id delegate;
-(NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javascriptString;
-(void)stopLoading;
-(void)loadRequest:(NSURLRequest *)request;    
#endif
@end
