//
//  PHPublisherContentRequest.h (formerly PHPublisherAdUnitRequest.h)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/5/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAPIRequest.h"
#import "PHContentView.h"

@class PHPublisherContentRequest;
@class PHContent;
@class PHReward;

@protocol PHPublisherContentRequestDelegate <NSObject>
@optional
-(void)requestWillGetContent:(PHPublisherContentRequest *)request;
-(void)request:(PHPublisherContentRequest *)request contentWillDisplay:(PHContent *)content;
-(void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content;
-(void)requestContentDidDismiss:(PHPublisherContentRequest *)request;

-(void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error;
-(void)request:(PHPublisherContentRequest *)request contentDidFailWithError:(NSError *)error;

#pragma mark - Content customization methods
-(UIImage *)request:(PHPublisherContentRequest *)request closeButtonImageForControlState:(UIControlState)state content:(PHContent *)content;
-(UIColor *)request:(PHPublisherContentRequest *)request borderColorForContent:(PHContent *)content;

#pragma mark - Reward unlocking methods
-(void)request:(PHPublisherContentRequest *)request unlockedReward:(PHReward *)reward;

@end

@interface PHPublisherContentRequest : PHAPIRequest<PHContentViewDelegate, PHAPIRequestDelegate> {
  NSString *_placement;
  BOOL _animated;
  NSMutableArray *_contentViews;
  UIView *_overlayView;
  BOOL _showsOverlayImmediately;
  UIButton *_closeButton;
}

+(id)requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate;

-(id)initWithApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate;

@property (nonatomic,retain) NSString *placement;
@property (nonatomic,assign) BOOL animated;
@property (nonatomic,readonly) NSMutableArray *contentViews;
@property (nonatomic,readonly) UIView *overlayView;
@property (nonatomic, assign) BOOL showsOverlayImmediately;

-(void)requestSubcontent:(NSDictionary *)queryParameters callback:(NSString *)callback source:(PHContentView *)source;
-(void)pushContent:(PHContent *)content;

-(BOOL)isValidReward:(NSDictionary *)rewardData;
-(void)requestRewards:(NSDictionary *)queryParameters callback:(NSString *)callback source:(PHContentView *)source;

-(void)requestCloseButton:(NSDictionary *)queryParameters callback:(NSString *)callback source:(PHContentView *)source;

@end
