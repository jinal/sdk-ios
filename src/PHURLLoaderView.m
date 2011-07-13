//
//  PHURLLoaderView.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/7/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHURLLoaderView.h"

#define ALPHA_IN 1.0f
#define ALPHA_OUT 0.0f
#define TRANSFORM_IN CGAffineTransformIdentity
#define TRANSFORM_OUT CGAffineTransformMakeScale(1.2, 1.2)

@interface PHURLLoaderView(Private)

-(void) finishShow;
-(void) finishDismiss;

@end

@implementation PHURLLoaderView
#pragma mark -
#pragma mark Instance
-(id)initWithTargetURLPath:(NSString *)urlPath{
  if ((self = [super initWithFrame:CGRectZero])) {
    self.loader.targetURL = [NSURL URLWithString:urlPath];
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.opaque = NO;
  }
  
  return self;
}

@synthesize delegate;

-(PHURLLoader *) loader{
  if (_loader == nil) {
    _loader = [[PHURLLoader alloc] init];
    _loader.delegate = self;
  }
  
  return _loader;
}

-(UIActivityIndicatorView *)activityView{
  if (_activityView == nil){
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.hidesWhenStopped = YES;
    [_activityView startAnimating];
  }
  
  return _activityView;
}

-(void) dealloc{
  [_loader release], _loader = nil;
  [_activityView release], _activityView = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark TTPopupViewController

-(void) show:(BOOL)animated{
  if (self.loader.targetURL == nil) {
    //nothing to do here, dismiss right away;
    return;
  }
  
  UIWindow *view = [[UIApplication sharedApplication] keyWindow];
  self.frame = [[UIScreen mainScreen] applicationFrame];
  
  self.activityView.center = self.center;
  [self addSubview:self.activityView];
  [view addSubview:self];
  
  self.alpha = ALPHA_OUT;
  self.activityView.transform = TRANSFORM_OUT;
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.25];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(finishShow)];
  self.alpha = ALPHA_IN;
  self.activityView.transform = TRANSFORM_IN;
  [UIView commitAnimations];
  
}

-(void) finishShow{
  [self.loader open];
}

-(void) dismiss:(BOOL)animated{
  if (animated) {
    self.alpha = ALPHA_IN;
    self.activityView.transform = TRANSFORM_IN;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishDismiss)];
    self.alpha = ALPHA_OUT;
    self.activityView.transform = TRANSFORM_OUT;
    [UIView commitAnimations];
  } else {
    [self performSelector:@selector(finishDismiss)];
  }
}

-(void) finishDismiss{
  [self removeFromSuperview];
}

#pragma mark -
#pragma mark PHURLLoaderDelegate
-(void) loaderFailed:(PHURLLoader *)loader{
  if ([self.delegate respondsToSelector:@selector(loaderFailed:)]) {
    [self.delegate loaderFailed:loader];
  }
  
  [self dismiss:YES];
}

-(void) loaderFinished:(PHURLLoader *)loader{
  if ([self.delegate respondsToSelector:@selector(loaderFinished:)]) {
    [self.delegate loaderFinished:loader];
  }
  
  [self dismiss:NO];
}

@end
