//
//  PHEventTrackingRequest.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHEventTrackingRequest.h"
#import "PHConstants.h"
#import "PHEventTracking.h"

@interface PHEventTrackingRequest(Private)

@end


// NOTE: have a send event records and a send all option


@implementation PHEventTrackingRequest

@synthesize event_queue_hash;

-(void)dealloc{
    [event_queue_hash release], event_queue_hash = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark PHAPIRequest

-(NSString *)urlPath{
    return PH_URL(/v3/publisher/tracking/);
}

-(NSDictionary *)additionalParameters{

    // Send just the current queue for now
    event_queue_hash = [[PHEventTracking eventTrackingForApp] getCurrentEventQueueHash];

    NSMutableDictionary *eventQueueDictionary = [[NSDictionary dictionaryWithContentsOfFile:[PHEventTracking getEventQueuePlistFile]] autorelease];
    NSMutableArray *event_queues = [eventQueueDictionary objectForKey:PHEVENT_TRACKING_EVENTQUEUES_KEY];
    NSDictionary *found_queue = nil;
    for (NSDictionary *queue in event_queues){
        
        NSString *queue_hash = [queue objectForKey:PHEVENT_TRACKING_EVENTQUEUE_HASH_KEY];
        if ([queue_hash isEqualToString:event_queue_hash])
            found_queue = queue;
    }
    if (!found_queue)
        return nil;
    
    // **************
    // Loop here with number should send per request - PH_MAX_EVENT_RECORDS_SEND_PER_REQUEST
    // **************

    NSString *queue_hash = [found_queue objectForKey:PHEVENT_TRACKING_EVENTQUEUE_HASH_KEY];
    NSString *event_record_filename = [[NSString stringWithFormat:@"%@/event_record-%@-0", [PHEventTracking defaultEventQueuePath], queue_hash] autorelease];
    PHEvent *event = [NSKeyedUnarchiver unarchiveObjectWithFile:event_record_filename];

    NSString *unixTime = [[[NSString alloc] initWithFormat:@"%0.0f", [event.eventTimestamp timeIntervalSince1970]] autorelease];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:event.eventType], @"event_type",
            event.eventData, @"event_data",
            unixTime, @"event_timestamp", nil];
}

#pragma mark - PHAPIRequest response delegate

-(void)didSucceedWithResponse:(NSDictionary *)responseData{

    // If successful clean up the event cache or event records that where sent to the server.
    [[PHEventTracking eventTrackingForApp] clearEventQueue:event_queue_hash];
    [event_queue_hash release], event_queue_hash = nil;

    if ([self.delegate respondsToSelector:@selector(request:didSucceedWithResponse:)]) {
        [self.delegate performSelector:@selector(request:didSucceedWithResponse:) withObject:self withObject:responseData];
    }
}

@end
