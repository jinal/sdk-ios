//
//  PHContentWebView.m (formerly PHAdUnitWebView.m)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/6/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHContentWebView.h"

#define ALPHA_OUT 0.0f
#define ALPHA_IN 1.0f

#define BOUNCE_OUT CGAffineTransformMakeScale(0.8,0.8)
#define BOUNCE_MID CGAffineTransformMakeScale(1.1,1.1)
#define BOUNCE_IN  CGAffineTransformIdentity

#define DURATION_1 0.0625
#define DURATION_2 0.125

@interface PHContentWebView(Private)

-(void)continueBounceIn;
-(void)finishBounceIn;
-(void)continueBounceOut;
-(void)finishBounceOut;

@end

@implementation PHContentWebView
@synthesize isAnimating = _isAnimating;

-(void)bounceInWithTarget:(id)target action:(SEL)action{
  if (!_isAnimating) {
    _target = target;
    _action = action;
    _isAnimating = YES;
    
    self.transform = BOUNCE_OUT;
    self.alpha = ALPHA_OUT;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:DURATION_1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(continueBounceIn)];
    
    self.transform = BOUNCE_MID;
    self.alpha = ALPHA_IN;
    
    [UIView commitAnimations];
  }
}

-(void)continueBounceIn{
  self.transform = BOUNCE_MID;
  self.alpha = ALPHA_IN;
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationDuration:DURATION_2];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(finishBounceIn)];
  
  self.transform = BOUNCE_IN;
  
  [UIView commitAnimations];
}

-(void)finishBounceIn{
  self.transform = BOUNCE_IN;
  self.alpha = ALPHA_IN;
  
  [_target performSelector:_action];
  _isAnimating = NO;
}

-(void)bounceOutWithTarget:(id)target action:(SEL)action{
  if (!_isAnimating) {
    _target = target;
    _action = action;
    _isAnimating = YES;
    
    self.transform = BOUNCE_IN;
    self.alpha = ALPHA_IN;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:DURATION_1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(continueBounceOut)];
    
    self.transform = BOUNCE_MID;
    
    [UIView commitAnimations];
  }
}

-(void)continueBounceOut{
  self.transform = BOUNCE_MID;
  self.alpha = ALPHA_IN;
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationDuration:DURATION_2];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(finishBounceOut)];
  
  self.transform = BOUNCE_OUT;
  self.alpha = ALPHA_OUT;
  
  [UIView commitAnimations];
}

-(void)finishBounceOut{
  self.transform = BOUNCE_OUT;
  self.alpha = ALPHA_OUT;
  
  [_target performSelector:_action];
  _isAnimating = NO;
}

@end
