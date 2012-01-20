//
//  PHEventTrackingRequest.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHEventTrackingRequest.h"
#import "PHConstants.h"

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

-(NSDictionary *)additionalParameters{

    // Loop here with number should send per request - PH_MAX_EVENT_RECORDS_SEND_PER_REQUEST
    NSString *unixTime = [[[NSString alloc] initWithFormat:@"%0.0f", [_event.eventTimestamp timeIntervalSince1970]] autorelease];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:_event.eventType], @"event_type",
            _event.eventData, @"event_data",
            unixTime, @"event_timestamp", nil];
}

#pragma mark - PHAPIRequest response delegate

-(void)didSucceedWithResponse:(NSDictionary *)responseData{

    // If successful clean up the event cache or event records that was sent to the server.

    if ([self.delegate respondsToSelector:@selector(request:didSucceedWithResponse:)]) {
        [self.delegate performSelector:@selector(request:didSucceedWithResponse:) withObject:self withObject:responseData];
    }
}


@end
