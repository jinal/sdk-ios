//
//  PHNotificationView.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/22/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHAPIRequest.h"
@class PHNotificationRenderer;

@interface PHNotificationView : UIView<PHAPIRequestDelegate>{
  NSString *_app;
  NSString *_secret;
  NSString *_placement;
  
  NSDictionary *_notificationData;
  PHNotificationRenderer *_notificationRenderer;
}

+(void)setRendererClass:(Class)class forType:(NSString *)type;
+(PHNotificationRenderer *)newRendererForData:(NSDictionary *)notificationData;

-(id)initWithApp:(NSString *)app secret:(NSString *)secret placement:(NSString *)placement;

@property (nonatomic,retain) NSDictionary *notificationData;

-(void)refresh;
-(void)test DEPRECATED_ATTRIBUTE;
-(void)clear;

@end
