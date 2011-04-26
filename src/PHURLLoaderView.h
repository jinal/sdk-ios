//
//  PHURLLoaderView.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/7/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHURLLoader.h"

@interface PHURLLoaderView : UIView<PHURLLoaderDelegate>{
  PHURLLoader *_loader;
  UIActivityIndicatorView *_activityView;
  id<NSObject, PHURLLoaderDelegate> _delegate;
}

-(id)initWithTargetURLPath:(NSString *)urlPath;

@property (nonatomic, readonly) PHURLLoader *loader;
@property (nonatomic, readonly) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) id<NSObject, PHURLLoaderDelegate> delegate;

-(void) show:(BOOL)animated;
-(void) dismiss:(BOOL)animated;

@end
