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


@implementation PHEventTimeInGame

#pragma mark - Static Methods

-(id)init{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotificationHandler:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotificationHandler:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotificationHandler:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotificationHandler:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminateNotificationHandler:) name:UIApplicationWillTerminateNotification object:nil];
    }
    
    return  self;
}

#pragma mark - Public Methods

-(void) registerApplicationDidStartEvent{

    _eventType = [NSStringFromClass([self class]) copy];
    _eventData = [PHEventTimeInGameApplicationStarted copy];
    _eventTimestamp = [[NSDate date] copy];
    [PHEventTracking addEvent:self];
}

#pragma mark - Event Notification Methods

-(void) applicationDidEnterBackgroundNotificationHandler:(NSNotification *) notification{

    _eventData = [PHEventTimeInGameApplicationDidEnterBackground copy];
    _eventTimestamp = [[NSDate date] copy];
    [PHEventTracking addEvent:self];
}

-(void) applicationWillEnterForegroundNotificationHandler:(NSNotification *) notification{
    
    _eventData = [PHEventTimeInGameApplicationWillEnterForeground copy];
    _eventTimestamp = [[NSDate date] copy];
    [PHEventTracking addEvent:self];
}

-(void) applicationDidBecomeActiveNotificationHandler:(NSNotification *) notification{
    
    _eventData = [PHEventTimeInGameApplicationDidBecomeActive copy];
    _eventTimestamp = [[NSDate date] copy];
    [PHEventTracking addEvent:self];
}

-(void) applicationWillResignActiveNotificationHandler:(NSNotification *) notification{
    
    _eventData = [PHEventTimeInGameApplicationWillResignActive copy];
    _eventTimestamp = [[NSDate date] copy];
    [PHEventTracking addEvent:self];
}

-(void) applicationWillTerminateNotificationHandler:(NSNotification *) notification{
    
    _eventData = [PHEventTimeInGameApplicationWillTerminate copy];
    _eventTimestamp = [[NSDate date] copy];
    [PHEventTracking addEvent:self];
}

@end
