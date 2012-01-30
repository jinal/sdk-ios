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

@interface PHAPIRequest(Private)
-(id)initWithApp:(NSString *)token secret:(NSString *)secret;
@end

@interface PHEventTrackingRequest(Private)
+(NSString *)getEventRequestPlistFile;
-(id)initWithApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate;
@end

@implementation PHEventTrackingRequest

@synthesize event_queue_hash;

-(void)dealloc{
    [event_queue_hash release], event_queue_hash = nil;
    [super dealloc];
}

+(NSString *)getEventRequestPlistFile{
    
    // Make sure directory exists
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:[PHEventTracking defaultEventQueuePath]]){

        [fileManager createDirectoryAtPath:[PHEventTracking defaultEventQueuePath]
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
    [fileManager release];
    
    return [[PHEventTracking defaultEventQueuePath] stringByAppendingPathComponent:PHEVENT_REQUEST_INFO_FILENAME];
}

#pragma mark -
#pragma mark PHAPIRequest

-(NSString *)urlPath{
    return PH_URL(/v3/publisher/tracking/);
}

+(id)requestForApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate{
    PHEventTrackingRequest *request = [PHEventTrackingRequest requestForApp:token secret:secret];
    if (!!request) {
        request.delegate = delegate;
        return request;
    } else {
        return [[[[self class] alloc] initWithApp:token secret:secret delegate:self] autorelease];
    }
}

-(id)initWithApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate{
    if ((self = [self initWithApp:token secret:secret])){
        self.delegate = delegate;
    }
    
    return self;
}

-(NSDictionary *)additionalParameters{

    NSInteger next_event_record = 0;
    NSMutableDictionary *eventRequestDictionary;
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    if (![fileManager fileExistsAtPath:[PHEventTracking defaultEventQueuePath]]){
        
        event_queue_hash = [[PHEventTracking eventTrackingForApp] getEventQueueToSendHash];
        eventRequestDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              event_queue_hash, PHEVENT_REQUEST_CURR_EVENT_QUEUE_HASH_KEY,
                                              [NSNumber numberWithInt:1], PHEVENT_REQUEST_NEXT_RECORD_KEY, nil];
        
    } else{

        eventRequestDictionary = [NSDictionary dictionaryWithContentsOfFile:[PHEventTracking getEventQueuePlistFile]];
        event_queue_hash = [eventRequestDictionary objectForKey:PHEVENT_REQUEST_CURR_EVENT_QUEUE_HASH_KEY];
        next_event_record = [[eventRequestDictionary objectForKey:PHEVENT_REQUEST_NEXT_RECORD_KEY] integerValue];
    }

    NSMutableArray *all_events = [[[NSMutableArray alloc] init] autorelease];
    NSInteger actual_sent_records = 0;
    for (int i = 0; i < PH_MAX_EVENT_RECORDS_SEND_PER_REQUEST; i++){

        NSString *event_record_filename = [NSString stringWithFormat:@"%@/event_record-%@-%d", [PHEventTracking defaultEventQueuePath], event_queue_hash, next_event_record];
        if (![fileManager fileExistsAtPath:event_record_filename])
            break;

        PHEvent *event = [NSKeyedUnarchiver unarchiveObjectWithFile:event_record_filename];

        NSString *unixTime = [[[NSString alloc] initWithFormat:@"%0.0f", [event.eventTimestamp timeIntervalSince1970]] autorelease];
        NSDictionary *event_record = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    event.eventType, @"event_type",
                                                    event.eventData, @"event_data",
                                                    unixTime, @"event_timestamp", nil];
        [all_events addObject:event_record];
        next_event_record++;
        actual_sent_records++;
    }

    [eventRequestDictionary setValue:[NSNumber numberWithInt:actual_sent_records] forKey:PHEVENT_REQUEST_TOTAL_SENT_RECORDS_KEY];
    [eventRequestDictionary writeToFile:[PHEventTracking getEventQueuePlistFile] atomically:YES];

    return [NSDictionary dictionaryWithObjectsAndKeys:
            all_events, @"events", nil];
}

#pragma mark - PHAPIRequest response delegate

-(void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData{

    // If the sent data is from the current event queue just remove the sent event records.
    if ([[PHEventTracking getCurrentEventQueueHash] isEqualToString:event_queue_hash]){

        NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
        NSDictionary *eventRequestDictionary = [NSDictionary dictionaryWithContentsOfFile:[PHEventTracking getEventQueuePlistFile]];

        if ([self.delegate respondsToSelector:@selector(request:didSucceedWithResponse:)]){
            [self.delegate performSelector:@selector(request:didSucceedWithResponse:) withObject:eventRequestDictionary withObject:responseData];
        }

        NSInteger next_event_record = [[eventRequestDictionary objectForKey:PHEVENT_REQUEST_NEXT_RECORD_KEY] integerValue];
        NSInteger actual_event_records = [[eventRequestDictionary objectForKey:PHEVENT_REQUEST_TOTAL_SENT_RECORDS_KEY] integerValue];
        for (int i = next_event_record; i < actual_event_records; i++){
            
            NSString *event_record_filename = [NSString stringWithFormat:@"%@/event_record-%@-%d", [PHEventTracking defaultEventQueuePath], event_queue_hash, i];
            if ([fileManager fileExistsAtPath:event_record_filename])
                [fileManager removeItemAtPath:event_record_filename error:NULL];
            next_event_record++;
        }

        [eventRequestDictionary setValue:[NSNumber numberWithInt:next_event_record] forKey:PHEVENT_REQUEST_NEXT_RECORD_KEY];
        [eventRequestDictionary setValue:[NSNumber numberWithInt:0] forKey:PHEVENT_REQUEST_TOTAL_SENT_RECORDS_KEY];
        [eventRequestDictionary writeToFile:[PHEventTracking getEventQueuePlistFile] atomically:YES];
    } else{

        // Not the current queue so remove all event queue records
        [[PHEventTracking eventTrackingForApp] clearEventQueue:event_queue_hash];
        [event_queue_hash release], event_queue_hash = nil;
    }
}

-(void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error{

}

@end
