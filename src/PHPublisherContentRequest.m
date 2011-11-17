//
//  PHPublisherContentRequest.m (formerly PHPublisherAdUnitRequest.m)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/5/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHPublisherContentRequest.h"
#import "PHPublisherSubContentRequest.h"
#import "PHContent.h"
#import "PHConstants.h"
#import "PHStringUtil.h"
#import "PHReward.h"
#import "JSON.h"

NSString *const PHPublisherContentRequestRewardIDKey = @"reward";
NSString *const PHPublisherContentRequestRewardQuantityKey = @"quantity";
NSString *const PHPublisherContentRequestRewardReceiptKey = @"receipt";
NSString *const PHPublisherContentRequestRewardSignatureKey = @"signature";

#define MAX_MARGIN 20

@interface PHAPIRequest(Private)
-(void)finish;
@end

@interface PHPublisherContentRequest(Private)
-(CGAffineTransform) transformForOrientation:(UIInterfaceOrientation)orientation;
-(void)placeCloseButton;
-(void)hideCloseButton;
-(void)showCloseButtonBecauseOfTimeout;
-(BOOL)showOverlayWindow;
-(void)hideOverlayWindow;

@property (nonatomic, readonly) UIButton *closeButton;
@end

@implementation PHPublisherContentRequest

+(id)requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate{
  return [[[[self class] alloc] initWithApp:token secret:secret placement:placement delegate:delegate] autorelease];
}

-(id)initWithApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate{
  if ((self = [self initWithApp:token secret:secret])) {
    self.placement = placement;
    self.delegate = delegate;
  }
  
  return self;
}

-(id)initWithApp:(NSString *)token secret:(NSString *)secret{
  if ((self = [super initWithApp:token secret:secret])){
    _animated = YES;
  }
  
  return self;
}

@synthesize placement = _placement;
@synthesize animated = _animated;
@synthesize showsOverlayImmediately = _showsOverlayImmediately;

-(NSMutableArray *)contentViews{
  if (_contentViews == nil){
    _contentViews = [[NSMutableArray alloc] init];
  }
  
  return _contentViews;
}

-(UIWindow *)overlayWindow{
  if (_overlayWindow == nil){
    _overlayWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayWindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  }
  
  return  _overlayWindow;
}

-(UIButton *)closeButton{
  if (_closeButton == nil) {
    _closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _closeButton.frame = CGRectMake(0, 0, 40, 40);
    _closeButton.hidden = YES;
    
    UIImage
    *closeImage = [self contentView:nil imageForCloseButtonState:UIControlStateNormal],
    *closeActiveImage = [self contentView:nil imageForCloseButtonState:UIControlStateHighlighted];
    
    closeImage = (!closeImage)? [UIImage imageNamed:@"PlayHaven.bundle/images/close.png"] : closeImage;
    closeActiveImage = (!closeActiveImage)?[UIImage imageNamed:@"PlayHaven.bundle/images/close-active.png"]: closeActiveImage;
    
    [_closeButton setImage:closeImage forState:UIControlStateNormal];
    [_closeButton setImage:closeActiveImage forState:UIControlStateHighlighted];
    
    [_closeButton addTarget:self action:@selector(dismissFromButton) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return _closeButton;
}

-(void)dealloc{
  [_placement release], _placement = nil;
  [_contentViews release], _contentViews = nil;
  [_closeButton release], _closeButton = nil;
  [_overlayWindow release], _overlayWindow = nil;
  [super dealloc];
}

#pragma mark - Internal UI management

-(void)placeCloseButton{
  if ([_closeButton superview] == nil) {   
    //TRACK_ORIENTATION see STOP_TRACK_ORIENTATION
    [[NSNotificationCenter defaultCenter] 
     addObserver:self
     selector:@selector(placeCloseButton) 
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    
  }
  
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  CGFloat barHeight = ([[UIApplication sharedApplication] isStatusBarHidden])? 0 : 20;
  
  CGRect screen = [[UIScreen mainScreen] applicationFrame];
  CGFloat width = screen.size.width, height = screen.size.height, X,Y;
  switch (orientation) {
    case UIInterfaceOrientationPortrait:
      X = width - MAX_MARGIN;
      Y = MAX_MARGIN + barHeight;
      break;
    case UIInterfaceOrientationPortraitUpsideDown:
      X = MAX_MARGIN;
      Y = height - MAX_MARGIN;
      break;
    case UIInterfaceOrientationLandscapeLeft:
      X = MAX_MARGIN + barHeight;
      Y = MAX_MARGIN;
      break;
    case UIInterfaceOrientationLandscapeRight:
      X = width - MAX_MARGIN;
      Y = height - MAX_MARGIN;
      break;
  }
  
  //find the topmost contentView
  PHContentView *topContentView = [self.contentViews lastObject];
  if (!!topContentView){
    CGRect contentFrame = [topContentView.content frameForOrientation:orientation];
    switch (orientation) {
      case UIInterfaceOrientationPortrait:
        X = MIN(X, CGRectGetMaxX(contentFrame));
        Y = MAX(Y, CGRectGetMinY(contentFrame) + barHeight);
        break;
        
      case UIInterfaceOrientationPortraitUpsideDown:
        X = MAX(X, width - CGRectGetMaxX(contentFrame));
        Y = MIN(Y, height - CGRectGetMinY(contentFrame));
        break;
        
      case UIInterfaceOrientationLandscapeLeft:
        X = MAX(X, CGRectGetMinY(contentFrame) + barHeight);
        Y = MAX(Y, height - CGRectGetMaxX(contentFrame));
        break;
        
      case UIInterfaceOrientationLandscapeRight:
        X = MIN(X, width - CGRectGetMinY(contentFrame));
        Y = MIN(Y, CGRectGetMaxX(contentFrame));
        break;
    }
  }
  
  self.closeButton.center = CGPointMake(X, Y);
  self.closeButton.transform = [self transformForOrientation:orientation];

  if (!!topContentView) {
    [self.overlayWindow insertSubview:self.closeButton aboveSubview:topContentView];
  } else {
    [self.overlayWindow addSubview:self.closeButton];
  }
}

-(void)showCloseButtonBecauseOfTimeout{
  self.closeButton.hidden = NO;
}

-(void)hideCloseButton{
    
  [PHPublisherContentRequest cancelPreviousPerformRequestsWithTarget:self selector:@selector(showCloseButtonBecauseOfTimeout) object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
  [_closeButton removeFromSuperview];
}

-(BOOL)showOverlayWindow{
  if (![self.overlayWindow isKeyWindow]) {
    [self.overlayWindow makeKeyAndVisible];
    return YES;
  }
  
  return NO;
}

-(void)hideOverlayWindow{
  self.overlayWindow.hidden = YES;
}

#pragma mark - PHAPIRequest

-(NSString *)urlPath{
  return PH_URL(/v3/publisher/content/);
}

-(NSDictionary *)additionalParameters{
  return [NSDictionary dictionaryWithObjectsAndKeys:
          self.placement, @"placement_id",
          nil];
}

-(void)finish{
    [PHAPIRequest cancelAllRequestsWithDelegate:self];
    
    [self hideOverlayWindow];
    [self hideCloseButton];
    
    [super finish];
}

-(void)afterConnectionDidFinishLoading{
    // don't do anything
}

-(void)didSucceedWithResponse:(NSDictionary *)responseData{
  PHContent *content = [PHContent contentWithDictionary:responseData];
  if (!!content) {
    if ([self.delegate respondsToSelector:@selector(request:contentWillDisplay:)]) {
      [self.delegate performSelector:@selector(request:contentWillDisplay:) withObject:self withObject:content];
    }
    
    [self showOverlayWindow];
    [self pushContent:content]; 
  } else {
    PH_NOTE(@"This request was successful but did not contain any displayable content. Dismissing now.");
    if ([self.delegate respondsToSelector:@selector(requestContentDidDismiss:)]) {
      [self.delegate performSelector:@selector(requestContentDidDismiss:) 
                          withObject:self];
    }
    
      [self finish];
  }
}

-(void)send{
  [super send];
  
  if ([self.delegate respondsToSelector:@selector(requestWillGetContent:)]) {
    [self.delegate performSelector:@selector(requestWillGetContent:) withObject:self];
  }
  

  if (self.showsOverlayImmediately) {
    [self showOverlayWindow];
  }
  
  [self placeCloseButton];
  [self performSelector:@selector(showCloseButtonBecauseOfTimeout) withObject:nil afterDelay:4.0];
}

#pragma mark -
#pragma mark Sub-content
-(void)requestSubcontent:(NSDictionary *)queryParameters callback:(NSString *)callback source:(PHContentView *)source{
  if (!!queryParameters && [queryParameters valueForKey:@"url"]) {
    PHPublisherSubContentRequest *request = [PHPublisherSubContentRequest requestForApp:self.token secret:self.secret];
    request.delegate = self;
    
    request.urlPath = [queryParameters valueForKey:@"url"];
    request.callback = callback;
    request.source = source;
    
    [request send];
  } else {
    NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"1",@"error", nil];
    [source sendCallback:callback withResponse:nil error:errorDict];
  }
}

-(void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData{
  PHContent *content = [PHContent contentWithDictionary:responseData];
  PHPublisherSubContentRequest *scRequest = (PHPublisherSubContentRequest *)request;
  if (!!content) {
    [self pushContent:content];
    [scRequest.source sendCallback:scRequest.callback withResponse:responseData error:nil];
  } else{
    NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"1",@"error", nil];
    [scRequest.source sendCallback:scRequest.callback withResponse:nil error:errorDict];
  }
}

-(void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error{
  PHPublisherSubContentRequest *scRequest = (PHPublisherSubContentRequest *)request;
  NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"1",@"error", nil];
  [scRequest.source sendCallback:scRequest.callback withResponse:nil error:errorDict];
}

-(void)pushContent:(PHContent *)content{
  PHContentView *contentView = [[PHContentView alloc] initWithContent:content];
  [contentView redirectRequest:@"ph://subcontent" toTarget:self action:@selector(requestSubcontent:callback:source:)];
  [contentView redirectRequest:@"ph://reward" toTarget:self action:@selector(requestRewards:callback:source:)];
  [contentView redirectRequest:@"ph://closeButton" toTarget:self action:@selector(requestCloseButton:callback:source:)];
  [contentView setDelegate:self];
  [contentView setTargetView:self.overlayWindow];
  [contentView show:self.animated];
  
  [self.contentViews addObject:contentView];
  
  [contentView release];
  
  [self placeCloseButton];
}

-(void)dismissFromButton{
  if ([self.contentViews count] > 0) {
    for (PHContentView *contentView in self.contentViews) {
      [contentView dismissFromButton];
    }
  } else {
      [self finish];
  }
}

-(CGAffineTransform) transformForOrientation:(UIInterfaceOrientation)orientation{
  if (orientation == UIInterfaceOrientationLandscapeLeft) {
    return CGAffineTransformMakeRotation(-M_PI/2);
  } else if (orientation == UIInterfaceOrientationLandscapeRight) {
    return CGAffineTransformMakeRotation(M_PI/2);
  } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
    return CGAffineTransformMakeRotation(-M_PI);
  } else {
    return CGAffineTransformIdentity;
  }
}


#pragma mark -
#pragma mark PHContentViewDelegate
-(void)contentViewDidLoad:(PHContentView *)contentView{  
  if ([self.contentViews count] == 1) {
    //only passthrough the first contentView load
    if ([self.delegate respondsToSelector:@selector(request:contentDidDisplay:)]) {
      [self.delegate performSelector:@selector(request:contentDidDisplay:) 
                          withObject:self 
                          withObject:contentView.content];
    }
  }
}

-(void)contentViewDidDismiss:(PHContentView *)contentView{
  [self.contentViews removeObject:contentView];
  
  if ([self.contentViews count] == 0) {
    //only passthrough the last contentView to dismiss
    if ([self.delegate respondsToSelector:@selector(requestContentDidDismiss:)]) {
      [self.delegate performSelector:@selector(requestContentDidDismiss:) 
                          withObject:self];
    }
    
    [self finish];
  }
}

-(void)contentView:(PHContentView *)contentView didFailWithError:(NSError *)error{
  [self.contentViews removeObject:contentView];
  
  if ([self.contentViews count] == 0) {
    //only passthrough the last contentView to error
    if ([self.delegate respondsToSelector:@selector(request:contentDidFailWithError:)]) {
      PH_NOTE(@"It seems like you're using the -request:contentDidFailWithError: delegate method. This delegate has been deprecated, please use -request:didFailWithError: instead.");
      [self.delegate performSelector:@selector(request:contentDidFailWithError:) 
                          withObject:self 
                          withObject:error];
    }else if ([self.delegate respondsToSelector:@selector(request:didFailWithError::)]) {
      [self.delegate performSelector:@selector(request:didFailWithError:) 
                          withObject:self 
                          withObject:error];
    } 
    
    [self finish];
  }
}

-(UIImage *)contentView:(PHContentView *)contentView imageForCloseButtonState:(UIControlState)state{
  if ([self.delegate respondsToSelector:@selector(request:closeButtonImageForControlState:content:)]) {
    return [(id <PHPublisherContentRequestDelegate>)self.delegate request:self closeButtonImageForControlState:state content:contentView.content];
  }
  
  return nil;
}

-(UIColor *)borderColorForContentView:(PHContentView *)contentView{
  if ([self.delegate respondsToSelector:@selector(request:borderColorForContent:)]) {
    return [(id <PHPublisherContentRequestDelegate>)self.delegate request:self borderColorForContent:contentView.content];
  }
  
  return nil;
}

#pragma mark - Reward unlocking methods
-(BOOL)isValidReward:(NSDictionary *)rewardData{
  NSString *reward = [rewardData valueForKey:PHPublisherContentRequestRewardIDKey];
  NSNumber *quantity = [rewardData valueForKey:PHPublisherContentRequestRewardQuantityKey];
  NSNumber *receipt = [rewardData valueForKey:PHPublisherContentRequestRewardReceiptKey];
  NSString *signature = [rewardData valueForKey:PHPublisherContentRequestRewardSignatureKey];
  
  NSString *generatedSignatureString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@",
                                        reward, 
                                        quantity, 
                                        [[UIDevice currentDevice] uniqueIdentifier], 
                                        receipt, 
                                        self.secret];
  NSString *generatedSignature = [PHStringUtil hexDigestForString:generatedSignatureString];
  
  return [generatedSignature isEqualToString:signature];
}

-(void)requestRewards:(NSDictionary *)queryParameters callback:(NSString *)callback source:(PHContentView *)source{
  NSArray *rewardsArray = [queryParameters valueForKey:@"rewards"];
  for (NSDictionary *rewardData in rewardsArray) {
    if ([self isValidReward:rewardData]) {
      PHReward *reward = [PHReward new];
      reward.name = [rewardData valueForKey:PHPublisherContentRequestRewardIDKey];
      reward.quantity = [[rewardData valueForKey:PHPublisherContentRequestRewardQuantityKey] integerValue];
      reward.receipt = [[rewardData valueForKey:PHPublisherContentRequestRewardReceiptKey] stringValue];
      
      if ([self.delegate respondsToSelector:@selector(request:unlockedReward:)]) {
        [(id <PHPublisherContentRequestDelegate>)self.delegate request:self unlockedReward:reward];
      }
    }
  }
  
  [source sendCallback:callback withResponse:nil error:nil];
}

#pragma mark - Close button control
-(void)requestCloseButton:(NSDictionary *)queryParameters callback:(NSString *)callback source:(PHContentView *)source{
  [PHPublisherContentRequest cancelPreviousPerformRequestsWithTarget:self selector:@selector(showCloseButtonBecauseOfTimeout) object:nil];
  
  if ([queryParameters valueForKey:@"hidden"]) {
    self.closeButton.hidden = [[queryParameters valueForKey:@"hidden"] boolValue];
  }
  
  NSArray *keys = [NSArray arrayWithObjects:@"hidden",nil];
  NSDictionary *response = [self.closeButton dictionaryWithValuesForKeys:keys];
  [source sendCallback:callback withResponse:response error:nil];
}


@end
