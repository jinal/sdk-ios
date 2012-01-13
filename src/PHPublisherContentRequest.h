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
@class PHPurchase;

typedef enum {
    PHPublisherContentRequestInitialized,
    PHPublisherContentRequestPreloading,
    PHPublisherContentRequestPreloaded,
    PHPublisherContentRequestDisplayingContent,
    PHPublisherContentRequestDone
} PHPublisherContentRequestState;

typedef NSString PHPublisherContentDismissType;
extern PHPublisherContentDismissType * const PHPublisherContentUnitTriggeredDismiss;
extern PHPublisherContentDismissType * const PHPublisherNativeCloseButtonTriggeredDismiss;
extern PHPublisherContentDismissType * const PHPublisherApplicationBackgroundTriggeredDismiss;
extern PHPublisherContentDismissType * const PHPublisherNoContentTriggeredDismiss;

@protocol PHPublisherContentRequestDelegate <NSObject>
@optional
-(void)requestWillGetContent:(PHPublisherContentRequest *)request;
-(void)requestDidGetContent:(PHPublisherContentRequest *)request;
-(void)request:(PHPublisherContentRequest *)request contentWillDisplay:(PHContent *)content;
-(void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content;
-(void)requestContentDidDismiss:(PHPublisherContentRequest *)request DEPRECATED_ATTRIBUTE;
-(void)request:(PHPublisherContentRequest *)request contentDidDismissWithType:(PHPublisherContentDismissType *)type;

-(void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error;
-(void)request:(PHPublisherContentRequest *)request contentDidFailWithError:(NSError *)error DEPRECATED_ATTRIBUTE;

#pragma mark - Content customization methods
-(UIImage *)request:(PHPublisherContentRequest *)request closeButtonImageForControlState:(UIControlState)state content:(PHContent *)content;
-(UIColor *)request:(PHPublisherContentRequest *)request borderColorForContent:(PHContent *)content;

#pragma mark - Reward unlocking methods
-(void)request:(PHPublisherContentRequest *)request unlockedReward:(PHReward *)reward;

#pragma mark - Purchase unlocking methods
-(void)request:(PHPublisherContentRequest *)request makePurchase:(PHPurchase *)purchase;

@end

@interface PHPublisherContentRequest : PHAPIRequest<PHContentViewDelegate, PHAPIRequestDelegate> {
    NSString *_placement;
    BOOL _animated;
    NSMutableArray *_contentViews;
    BOOL _showsOverlayImmediately;
    UIButton *_closeButton;
    
    UIView *_overlayWindow;
    PHContent *_content;
    
    PHPublisherContentRequestState _state;
    PHPublisherContentRequestState _targetState;
}

+(id)requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate;

@property (nonatomic,retain) NSString *placement;
@property (nonatomic,assign) BOOL animated;
@property (nonatomic,readonly) NSMutableArray *contentViews;
@property (nonatomic, assign) BOOL showsOverlayImmediately;
@property (nonatomic, readonly) UIView *overlayWindow;

-(void)preload;

-(void)requestSubcontent:(NSDictionary *)queryParameters callback:(NSString *)callback source:(PHContentView *)source;


-(BOOL)isValidReward:(NSDictionary *)rewardData;
-(void)requestRewards:(NSDictionary *)queryParameters callback:(NSString *)callback source:(PHContentView *)source;

-(BOOL)isValidPurchase:(NSDictionary *)purchaseData;
-(void)requestPurchases:(NSDictionary *)queryParameters callback:(NSString *)callback source:(PHContentView *)source;

-(void)requestCloseButton:(NSDictionary *)queryParameters callback:(NSString *)callback source:(PHContentView *)source;

@end
