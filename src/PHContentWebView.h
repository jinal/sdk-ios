//
//  PHContentWebView.h (formerly PHAdUnitWebView.h)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/6/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PHContentWebView : UIWebView {
  SEL _action;
  id _target;
  BOOL _isAnimating;
}

@property (nonatomic, readonly) BOOL isAnimating;

-(void)bounceInWithTarget:(id)target action:(SEL)action;
-(void)bounceOutWithTarget:(id)target action:(SEL)action;

@end
