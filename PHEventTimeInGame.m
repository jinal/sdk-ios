//
//  PHEventTimeInGame.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHEventTimeInGame.h"
#import "PHEventTracking.h"

static NSString *const PHEventTimeInGameApplicationStarted = @"phEventAppStarted";
static NSString *const PHEventTimeInGameApplicationDidEnterBackground = @"phEventAppDidEnterBackground";
static NSString *const PHEventTimeInGameApplicationWillEnterForeground = @"phEventAppWillEnterForeground";
static NSString *const PHEventTimeInGameApplicationDidBecomeActive = @"phEventAppDidBecomeActive";
static NSString *const PHEventTimeInGameApplicationWillResignActive = @"phEventAppWillResignActive";
static NSString *const PHEventTimeInGameApplicationWillTerminate = @"phEventAppWillTerminate";


@interface PHEventTimeInGame(Private)
-(void) applicationEnteredBackgroundNotificationHandler;
-(void) applicationWillEnterForegroundNotificationHandler;
-(void) applicationDidBecomeActiveNotificationHandler;
-(void) applicationWillResignActiveNotificationHandler;
-(void) applicationWillTerminateNotificationHandler;
@end

@implementation PHEventTimeInGame

#pragma mark - Static Methods

+(void)initialize{
    if  (self == [PHEventTimeInGame class]){
        // Create the event phEventAppStarted when this object is created? (in initialize) PHEventTracking create this event type - PHEventTimeInGame
        // since it is needed for all event tracking anyway in the application
        // *** Put into the Event queue as first object. generate timestamp, hash, etc and always first event of event queue
        [[NSNotificationCenter defaultCenter] addObserver:[PHEventTimeInGame class] selector:@selector(applicationDidEnterBackgroundNotificationHandler) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:[PHEventTimeInGame class] selector:@selector(applicationWillEnterForegroundNotificationHandler) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:[PHEventTimeInGame class] selector:@selector(applicationDidBecomeActiveNotificationHandler) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:[PHEventTimeInGame class] selector:@selector(applicationWillResignActiveNotificationHandler) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:[PHEventTimeInGame class] selector:@selector(applicationWillTerminateNotificationHandler) name:UIApplicationWillTerminateNotification object:nil];
    }
}

#pragma mark - Public Methods

+(PHEventTimeInGame *) createPHEventApplicationDidStart{

    PHEventTimeInGame *newEvent = [[PHEventTimeInGame alloc] initWithData:PHEventTypeTimeInGame withData:PHEventTimeInGameApplicationDidEnterBackground withTimestamp:[NSDate date]];
    [PHEventTracking addEvent:newEvent];
    return newEvent;
}

#pragma mark - Event Notification Methods

-(void) applicationDidEnterBackgroundNotificationHandler{

    PHEventTimeInGame *newEvent = [[PHEventTimeInGame alloc] initWithData:PHEventTypeTimeInGame withData:PHEventTimeInGameApplicationDidEnterBackground withTimestamp:[NSDate date]];
    [PHEventTracking addEvent:newEvent];
    [newEvent release];
}

-(void) applicationWillEnterForegroundNotificationHandler{
    
    PHEventTimeInGame *newEvent = [[PHEventTimeInGame alloc] initWithData:PHEventTypeTimeInGame withData:PHEventTimeInGameApplicationWillEnterForeground withTimestamp:[NSDate date]];
    [PHEventTracking addEvent:newEvent];
    [newEvent release];
}

-(void) applicationDidBecomeActiveNotificationHandler{
    
    PHEventTimeInGame *newEvent = [[PHEventTimeInGame alloc] initWithData:PHEventTypeTimeInGame withData:PHEventTimeInGameApplicationDidBecomeActive withTimestamp:[NSDate date]];
    [PHEventTracking addEvent:newEvent];
    [newEvent release];
}

-(void) applicationWillResignActiveNotificationHandler{
    
    PHEventTimeInGame *newEvent = [[PHEventTimeInGame alloc] initWithData:PHEventTypeTimeInGame withData:PHEventTimeInGameApplicationWillResignActive withTimestamp:[NSDate date]];
    [PHEventTracking addEvent:newEvent];
    [newEvent release];
}

-(void) applicationWillTerminateNotificationHandler{
    
    PHEventTimeInGame *newEvent = [[PHEventTimeInGame alloc] initWithData:PHEventTypeTimeInGame withData:PHEventTimeInGameApplicationWillTerminate withTimestamp:[NSDate date]];
    [PHEventTracking addEvent:newEvent];
    [newEvent release];
}

@end
