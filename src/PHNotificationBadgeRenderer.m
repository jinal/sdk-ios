//
//  PHNotificationBadgeRenderer.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/22/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHNotificationBadgeRenderer.h"

static UIImage *BadgeImage;

@implementation PHNotificationBadgeRenderer

+(void)initialize{
  if (self == [PHNotificationBadgeRenderer class]) {
    UIImage *badge = [UIImage imageNamed:@"PlayHaven.bundle/images/badge.png"];
    BadgeImage = [[badge stretchableImageWithLeftCapWidth:14 topCapHeight:0] retain];
  }
}

-(void)drawNotification:(NSDictionary *)notificationData inRect:(CGRect)rect{
  NSString *value = [notificationData valueForKey:@"value"];
  if ([value isEqualToString:@"0"]) {
    return;
  }
  CGSize notificationSize = [self sizeForNotification:notificationData];
  [BadgeImage drawInRect:CGRectMake(0, 0, notificationSize.width, BadgeImage.size.height)];
  
  [[UIColor whiteColor] set]; 
  [value drawAtPoint:CGPointMake(10.0f, 1.0f) withFont:[UIFont boldSystemFontOfSize:17.0f]];
}

-(CGSize)sizeForNotification:(NSDictionary *)notificationData{
  NSString *value = [notificationData valueForKey:@"value"];
  if ([value isEqualToString:@"0"]) {
    return CGSizeZero;
  }
  
  CGFloat valueWidth = [value sizeWithFont:[UIFont boldSystemFontOfSize:17.0f]].width + 20.0f;
  return CGSizeMake(valueWidth, BadgeImage.size.height);
}

@end
