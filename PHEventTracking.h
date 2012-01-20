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

+(id) eventTrackingForApp;

/*
 *  Sends collected event tracking data to server. It sends PH_MAX_EVENT_RECORDS_SEND_PER_REQUEST
 *  event records each time this selector if called. It will start at the oldest event queue and
 *  make it's way to the current event queue. All sent events are deleted from the event cache.
 */
+(void) sendEventTrackingDataToServer;

/*
 *  Sends the current event queue and all the event records. It will then reset the next event
 *  record back to 0 to start recording new events again at the start of the queue. All sent
 *  events are deleted from the event cache.
 */
+(void) sendEventQueueToServer;

/*
 * Adds event to the current event queue.
 */
+(void) addEvent:(PHEvent *)event;

/*
 * Selectors for cleaning and clearing event queue cache.
 */
+(void) clearCurrentEventQueue;
+(void) clearEventQueue:(NSString *)qhash;
+(void) clearEventQueueCache;

@end
