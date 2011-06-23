//
//  PHNotificationRenderer.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/22/11.
//  Copyright 2011 Playhaven. All rights reserved.
//
/*
 Base notification rendering class. This trivial implementation is used when the type of notification being rendered is unknown, which will result in no badge being rendered. See PHNotificationBadgeRenderer for a default badge implementation.
*/

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface PHNotificationRenderer : NSObject
-(void)drawNotification:(NSDictionary *)notificationData inRect:(CGRect)rect;
-(CGSize)sizeForNotification:(NSDictionary *)notificationData;
@end
