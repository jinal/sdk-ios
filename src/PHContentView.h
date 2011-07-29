//
//  PHContentView.h (formerly PHAdUnitView.h)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/1/11.
//  Copyright 2011 Playhaven. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PHURLLoader.h"
@class PHContent;
@class PHContentView;
@class PHContentWebView;
@protocol PHContentViewDelegate<NSObject>
@optional
-(void) contentViewDidShow:(PHContentView *)contentView;
-(void) contentViewDidLoad:(PHContentView *)contentView;
-(void) contentViewDidDismiss:(PHContentView *)contentView;
-(void) contentView:(PHContentView *)contentView didFailWithError:(NSError *)error;
-(UIImage *) contentView:(PHContentView *)contentView imageForCloseButtonState:(UIControlState) state;
-(UIColor *) borderColorForContentView:(PHContentView *)contentView;
@end

@interface PHContentView : UIView<UIWebViewDelegate, PHURLLoaderDelegate> {
  PHContent *_content;
  UIInterfaceOrientation _orientation;
  NSObject<PHContentViewDelegate> *_delegate;
  
  PHContentWebView *_webView;
  BOOL _willAnimate;
  
  NSMutableDictionary *_redirects;
  UIActivityIndicatorView *_activityView;
  
  UIButton *_closeButton;
  UIView *_targetView;
}

-(id)initWithContent:(PHContent *)content;

@property(nonatomic, readonly) PHContent *content;
@property(nonatomic, assign) NSObject<PHContentViewDelegate> *delegate;
@property(nonatomic, assign) UIView *targetView;

-(void) show:(BOOL)animated;
-(void) dismiss:(BOOL)animated;

-(void)redirectRequest:(NSString *)urlPath toTarget:(id)target action:(SEL)action;
-(void)sendCallback:(NSString *)callback withResponse:(id)response error:(id)error;


-(void)dismissFromButton;
@end
