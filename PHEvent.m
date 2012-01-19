//
//  PHEvent.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHEvent.h"

@implementation PHEvent

@synthesize eventType, eventData, eventTimestamp;


#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _eventType = [decoder decodeIntegerForKey:@"type"];
        _eventData = [decoder decodeObjectForKey:@"data"];
        _eventTimestamp = [decoder decodeObjectForKey:@"timestamp"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:_eventType forKey:@"type"];
    [encoder encodeObject:_eventData forKey:@"data"];
    [encoder encodeObject:_eventTimestamp forKey:@"timestamp"];
}

#pragma mark NSObject

- (void)dealloc{
    
    [super dealloc];
    [_eventData release], _eventData = nil;
    [_eventTimestamp release], _eventTimestamp = nil;
}


@end
