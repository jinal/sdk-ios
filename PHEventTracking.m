//
//  PHEventTracking.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHEventTracking.h"
#import "PHConstants.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const kPHEventQueueInfoFileName = @"event_queue_cache.plist";
static NSString *const PHEventTrackingEventQueueHashKey = @"event_queue_hash";
static NSString *const PHEventTrackingCurrentEventQueueKey = @"event_queue_first";
static NSString *const PHEventTrackingNextEventQueueKey = @"event_queue_next";
static NSString *const PHEventTrackingEventQueuesKey = @"event_queues";
static NSString *const PHEventTrackingNextEventRecordKey = @"event_record_next";


@interface PHEventTracking(Private)
+(NSString *) defaultEventQueuePath;
+(NSString *) getEventQueuePlistFile;
+(NSString *) cacheKeyForTimestamp:(NSDate *)date;
@end

@implementation PHEventTracking

#pragma mark - Static Methods

+(void) initialize{

    if  (self == [PHEventTracking class]){
        
        PHEventTimeInGame *appStartedEvent = [PHEventTimeInGame createPHEventApplicationDidStart];

        NSString *currentEventQueueHash = [[PHEventTracking cacheKeyForTimestamp:[appStartedEvent eventTimestamp]] autorelease];
        NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
        if (![fileManager fileExistsAtPath:[PHEventTracking getEventQueuePlistFile]]){

            // no plist file so start fresh event queue cache
            NSMutableArray *event_queues = [[NSMutableArray alloc] initWithCapacity:PH_MAX_EVENT_QUEUES];
            for (int i = 0; i < PH_MAX_EVENT_QUEUES; i++){
                NSDictionary *event_queue = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [NSNumber numberWithInt:0], PHEventTrackingNextEventRecordKey,
                                             currentEventQueueHash, PHEventTrackingEventQueueHashKey, nil];
                currentEventQueueHash = @"";    // Set the first hash only
                [event_queues addObject:event_queue];
                [event_queue release];
            }

            NSDictionary *eventQueueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:0], PHEventTrackingCurrentEventQueueKey,
                                                  [NSNumber numberWithInt:1], PHEventTrackingNextEventQueueKey,
                                                  event_queues, PHEventTrackingEventQueuesKey, nil];

            [eventQueueDictionary writeToFile:[PHEventTracking getEventQueuePlistFile] atomically:YES];
            [eventQueueDictionary release];
        } else{

            // Get current plist and update to start a new event queue
            NSMutableDictionary *eventQueueDictionary = [[NSDictionary dictionaryWithContentsOfFile:[PHEventTracking getEventQueuePlistFile]] autorelease];
            NSMutableArray *event_queues = [eventQueueDictionary objectForKey:PHEventTrackingEventQueuesKey];
            
            NSInteger current_event_queue = [[eventQueueDictionary objectForKey:PHEventTrackingCurrentEventQueueKey] integerValue];
            NSInteger next_event_queue = [[eventQueueDictionary objectForKey:PHEventTrackingNextEventQueueKey] integerValue];

            current_event_queue = next_event_queue;
            NSDictionary *event_queue = [event_queues objectAtIndex:current_event_queue];
            [event_queue setValue:currentEventQueueHash forKey:PHEventTrackingEventQueueHashKey];
            [event_queue setValue:[NSNumber numberWithInt:0] forKey:PHEventTrackingNextEventRecordKey];

            next_event_queue++;
            if (next_event_queue > PH_MAX_EVENT_QUEUES){
                next_event_queue = 0;
            }
                
            [eventQueueDictionary setValue:[NSNumber numberWithInt:current_event_queue] forKey:PHEventTrackingCurrentEventQueueKey];
            [eventQueueDictionary setValue:[NSNumber numberWithInt:next_event_queue] forKey:PHEventTrackingNextEventQueueKey];
            [eventQueueDictionary writeToFile:[PHEventTracking getEventQueuePlistFile] atomically:YES];
        }

        [PHEventTracking addEvent:appStartedEvent];
        [appStartedEvent release];
    }
}

+(NSString *) defaultEventQueuePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"PHEventQueue"];
}

+(NSString *)getEventQueuePlistFile{
    
    // Make sure directory exists
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:[PHEventTracking defaultEventQueuePath]])
    {
        [fileManager createDirectoryAtPath:[PHEventTracking defaultEventQueuePath]
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
    [fileManager release];
    
    return [[PHEventTracking defaultEventQueuePath] stringByAppendingPathComponent:kPHEventQueueInfoFileName];
}

+(NSString *) cacheKeyForTimestamp:(NSDate *)date
{
    NSString *unixTime = [[[NSString alloc] initWithFormat:@"%0.0f", [date timeIntervalSince1970]] autorelease];
    const char *str = [unixTime UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

#pragma mark PHEventTracking (event tracking)

+(void) addEvent:(PHEvent *)event{

    NSMutableDictionary *eventQueueDictionary = [[NSDictionary dictionaryWithContentsOfFile:[PHEventTracking getEventQueuePlistFile]] autorelease];
    NSInteger current_event_queue = [[eventQueueDictionary objectForKey:PHEventTrackingCurrentEventQueueKey] integerValue];
    NSMutableArray *event_queues = [eventQueueDictionary objectForKey:PHEventTrackingEventQueuesKey];
    NSDictionary *event_queue = [event_queues objectAtIndex:current_event_queue];
    NSString *queue_hash = [event_queue objectForKey:PHEventTrackingEventQueueHashKey];
    NSInteger next_event_record = [[event_queue objectForKey:PHEventTrackingNextEventRecordKey] integerValue];
    NSString *event_record_filename = [[NSString stringWithFormat:@"%@/event_record-%@-%d", [PHEventTracking defaultEventQueuePath], queue_hash, next_event_record] autorelease];
    next_event_record++;
    if (next_event_record > PH_MAX_EVENT_RECORDS)
        return;
    [event saveEventToDisk:event_record_filename];
    [event_queue setValue:[NSNumber numberWithInt:next_event_record] forKey:PHEventTrackingNextEventRecordKey];
    // have to reset array so value written?? try not and see if works - Probably have to do ***
    //[eventQueueDictionary setValue:event_queues forKey:PHEventTrackingEventQueuesKey];
    [eventQueueDictionary writeToFile:[PHEventTracking getEventQueuePlistFile] atomically:YES];
}

+(void) clearEventQueue{
    // clear current queue back to 0 - removes event records too
    NSMutableDictionary *eventQueueDictionary = [[NSDictionary dictionaryWithContentsOfFile:[PHEventTracking getEventQueuePlistFile]] autorelease];
    NSInteger current_event_queue = [[eventQueueDictionary objectForKey:PHEventTrackingCurrentEventQueueKey] integerValue];
    NSMutableArray *event_queues = [eventQueueDictionary objectForKey:PHEventTrackingEventQueuesKey];
    NSDictionary *event_queue = [event_queues objectAtIndex:current_event_queue];
    NSString *queue_hash = [event_queue objectForKey:PHEventTrackingEventQueueHashKey];
    NSInteger next_event_record = [[event_queue objectForKey:PHEventTrackingNextEventRecordKey] integerValue];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    for (int i = 0; i < next_event_record; i++){
        
        NSString *event_record_filename = [[NSString stringWithFormat:@"%@/event_record-%@-%d", [PHEventTracking defaultEventQueuePath], queue_hash, i] autorelease];
        [fileManager removeItemAtPath:event_record_filename error:nil];
    }
    [fileManager release];
    [event_queue setValue:[NSNumber numberWithInt:next_event_record] forKey:PHEventTrackingNextEventRecordKey];
    // have to reset array so value written?? try not and see if works - Probably have to do ***
    //[eventQueueDictionary setValue:event_queues forKey:PHEventTrackingEventQueuesKey];
    [eventQueueDictionary writeToFile:[PHEventTracking getEventQueuePlistFile] atomically:YES];
}

+(void) clearEventQueueCache{
    // clears all event queues and plist files
    [[[[NSFileManager alloc] init] autorelease] removeItemAtPath:[PHEventTracking getEventQueuePlistFile] error:nil];
}

#pragma mark NSObject

-(void) dealloc{

    [super dealloc];
}

@end
