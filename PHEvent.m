//
//  PHEvent.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHEvent.h"

@implementation PHEvent

@synthesize eventType = _eventType;
@synthesize eventData = _eventData;
@synthesize eventTimestamp = _eventTimestamp;

#pragma mark NSCoding

#define kEventTypeKey        @"type"
#define kEventDataKey        @"data"
#define kEventTimestampKey   @"timestamp"

-(id) initWithData:(NSString *)type withData:(NSString *)data withTimestamp:(NSDate *)timestamp{
    self = [self init];
    if (self) {
        _eventType = type;
        _eventData = data;
        _eventTimestamp = timestamp;
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        _eventType = [decoder decodeObjectForKey:kEventTypeKey];
        _eventData = [decoder decodeObjectForKey:kEventDataKey];
        _eventTimestamp = [decoder decodeObjectForKey:kEventTimestampKey];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_eventType forKey:kEventTypeKey];
    [encoder encodeObject:_eventData forKey:kEventDataKey];
    [encoder encodeObject:_eventTimestamp forKey:kEventTimestampKey];
}

- (void) saveEventToDisk:(NSString *)fileName{
    
    [NSKeyedArchiver archiveRootObject:self toFile:fileName];    
}

#pragma mark NSObject

- (void) dealloc{
    
    [super dealloc];
    [_eventType release], _eventType = nil;
    [_eventData release], _eventData = nil;
    [_eventTimestamp release], _eventTimestamp = nil;
}


@end
