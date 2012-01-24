//
//  PHEventTrackingRequestTest.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/23/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import "PHPublisherOpenRequest.h"
#import "PHEventTrackingRequest.h"
#import "PHEventTracking.h"
#import "PHEvent.h"
#import "PHConstants.h"

#define PUBLISHER_TOKEN @"PUBLISHER_TOKEN"
#define PUBLISHER_SECRET @"PUBLISHER_SECRET"

@interface PHEventTest : PHEvent{
    
}
@end

@interface PHEventTrackingRequestTest : SenTestCase<PHAPIRequestDelegate>{
    
    PHPublisherOpenRequest *_openRequest;
    PHEventTrackingRequest *_request;
}
@end

@implementation PHEventTrackingRequestTest

-(void)setUp{
    
    // Fill an event queue withe eventTest records
    for (int i = 0; i < PH_MAX_EVENT_RECORDS; i++){
        
        NSString *test_data = [NSString stringWithFormat:@"Test data event record = %d", i];
        PHEventTest *_eventTest = [[PHEventTest alloc] initWithData:PHEventTypeTimeInGame withData:test_data withTimestamp:[NSDate date]];
        [PHEventTracking addEvent:_eventTest];
        [_eventTest release];
        [test_data release];
    }
}

-(void)testInstance{
    // 1) add PH_MAX_EVENT_RECORDS_SEND_PER_REQUEST events and make sure actual_sent is same when request is done
    // 2) do another with 500 and send 4 times so all 500 sent?

    // Do an open request to set up event tracking
    _openRequest = [PHPublisherOpenRequest requestForApp:PUBLISHER_TOKEN secret:PUBLISHER_SECRET];
    STAssertNotNil(_openRequest, @"expected request instance, got nil");

    PHEventTracking *trackingObject = [PHEventTracking eventTrackingForApp];
    STAssertNotNil(trackingObject, @"expected PHEventTracking instance, got nil");

    _request = [PHEventTrackingRequest requestForApp:PUBLISHER_TOKEN secret:PUBLISHER_SECRET delegate:self];
    STAssertNotNil(_request, @"expected request instance, got nil");
}

-(void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData{

    NSInteger actual_event_records = [[responseData objectForKey:PHEVENT_REQUEST_TOTAL_SENT_RECORDS_KEY] integerValue];
    NSString *event_queue_hash_sent = [responseData objectForKey:PHEVENT_REQUEST_CURR_EVENT_QUEUE_HASH_KEY];
    if ([event_queue_hash_sent isEqualToString:[PHEventTracking getCurrentEventQueueHash]])
        STFail(@"Event Queue hash and sent queue hash MUST match!");

    STAssertEquals([[NSNumber numberWithInt:actual_event_records], [NSNumber numberWithInt:0], @"sent 0 items");

    // Should send PH_MAX_EVENT_RECORDS_SEND_PER_REQUEST in 1 request
    if (actual_event_records] != PH_MAX_EVENT_RECORDS_SEND_PER_REQUEST)
        STFail(@"Must send PH_MAX_EVENT_RECORDS_SEND_PER_REQUEST items per PHEventTrackingRequest (Event queue contains PH_MAX_EVENT_RECORDS event records)");
}

-(void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error{
    STFail(@"Was not expecting an error!");
}

-(void)tearDown{
    [_request release], _request = nil;
    [_openRequest release], _openRequest = nil;
}

@end
