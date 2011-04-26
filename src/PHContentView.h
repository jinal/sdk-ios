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
@end

@interface _Redirect : NSObject {
  id _target;
  SEL _action;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@end

@interface PHContentView : UIView<UIWebViewDelegate, PHURLLoaderDelegate> {
  PHContent *_content;
  UIInterfaceOrientation _orientation;
  NSObject<PHContentViewDelegate> *_delegate;
  
  PHContentWebView *_webView;
  UINavigationBar *_navBar;
  BOOL _willAnimate;
  
  NSMutableDictionary *_redirects;
  UIActivityIndicatorView *_activityView;
  
  UIButton *_closeButton;
}

-(id)initWithContent:(PHContent *)content;

@property(nonatomic, readonly) PHContent *content;
@property(nonatomic, assign) NSObject<PHContentViewDelegate> *delegate;

-(void) show:(BOOL)animated;
-(void) dismiss:(BOOL)animated;

-(void)redirectRequest:(NSString *)urlPath toTarget:(id)target action:(SEL)action;

@end
