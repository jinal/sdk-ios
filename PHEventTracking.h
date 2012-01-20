//
//  PHEventTracking.h
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHEvent.h"
#import "PHEventTimeInGame.h"

@interface PHEventTracking : NSObject{

}

/*
 * Sets up the application for event tracking. After this is called event records will be recorded.
 */
+(id) eventTrackingForApp;

/*
 * Adds event to the current event queue.
 */
+(void) addEvent:(PHEvent *)event;

/*
 *  Returns the current event queues hash
 */
+(NSString *) getCurrentEventQueueHash;

/*
 * Selectors for cleaning and clearing event queue cache.
 */
+(void) clearCurrentEventQueue;
+(void) clearEventQueue:(NSString *)qhash;
+(void) clearEventQueueCache;

@end
