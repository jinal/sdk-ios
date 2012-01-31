//
//  PHEventTimeInGame.h
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PHEvent.h"

@interface PHEventTimeInGame : PHEvent{
    
}

-(void) registerApplicationDidStartEvent;
-(void) applicationDidEnterBackgroundNotificationHandler:(NSNotification *) notification;
-(void) applicationWillEnterForegroundNotificationHandler:(NSNotification *) notification;
-(void) applicationDidBecomeActiveNotificationHandler:(NSNotification *) notification;
-(void) applicationWillResignActiveNotificationHandler:(NSNotification *) notification;
-(void) applicationWillTerminateNotificationHandler:(NSNotification *) notification;

@end
