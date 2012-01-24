//
//  PHEventTrackingRequest.h
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAPIRequest.h"
#import "PHEvent.h"

@interface PHEventTrackingRequest : PHAPIRequest<PHAPIRequestDelegate>{
    NSString *event_queue_hash;
}

@property (nonatomic, copy) NSString *event_queue_hash;

+(id)requestForApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate;

#define PHEVENT_REQUEST_INFO_FILENAME @"event_request_cache.plist"
#define PHEVENT_REQUEST_CURR_EVENT_QUEUE_HASH_KEY @"eventrequest_next_record"
#define PHEVENT_REQUEST_NEXT_RECORD_KEY @"eventrequest_next_record"
#define PHEVENT_REQUEST_TOTAL_SENT_RECORDS_KEY @"eventrequest_records_sent"

@end
