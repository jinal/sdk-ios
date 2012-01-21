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

@synthesize event, event_queue_hash;

-(void)dealloc{
    [_event release], _event = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark PHAPIRequest

-(NSString *)urlPath{
    return PH_URL(/v3/publisher/tracking/);
}

/*
 +(void) sendEventQueueToServer{
 
 // Get and send the current event queue
 NSMutableDictionary *eventQueueDictionary = [[NSDictionary dictionaryWithContentsOfFile:[PHEventTracking getEventQueuePlistFile]] autorelease];
 NSInteger current_event_queue = [[eventQueueDictionary objectForKey:PHEventTrackingCurrentEventQueueKey] integerValue];
 NSMutableArray *event_queues = [eventQueueDictionary objectForKey:PHEventTrackingEventQueuesKey];
 NSDictionary *event_queue = [event_queues objectAtIndex:current_event_queue];
 NSString *queue_hash = [event_queue objectForKey:PHEventTrackingEventQueueHashKey];
 
 PHEventTrackingRequest *request = [PHEventTrackingRequest requestForApp:@"token" secret:@"secret"];
 //    request.delegate = self;
 request.event_queue_hash = queue_hash;
 [request send];
 
 }
*/

-(NSDictionary *)additionalParameters{

    event_queue_hash = [[PHEventTracking eventTrackingForApp] getCurrentEventQueueHash];

    // Loop here with number should send per request - PH_MAX_EVENT_RECORDS_SEND_PER_REQUEST
    NSString *unixTime = [[[NSString alloc] initWithFormat:@"%0.0f", [_event.eventTimestamp timeIntervalSince1970]] autorelease];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:_event.eventType], @"event_type",
            _event.eventData, @"event_data",
            unixTime, @"event_timestamp", nil];
}

#pragma mark - PHAPIRequest response delegate

-(void)didSucceedWithResponse:(NSDictionary *)responseData{

    // If successful clean up the event cache or event records that where sent to the server.
    [[PHEventTracking eventTrackingForApp] clearEventQueue:event_queue_hash];

    if ([self.delegate respondsToSelector:@selector(request:didSucceedWithResponse:)]) {
        [self.delegate performSelector:@selector(request:didSucceedWithResponse:) withObject:self withObject:responseData];
    }
}

@end
