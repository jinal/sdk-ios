//
//  PHEvent.h
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHEvent : NSObject <NSCoding>{
    NSString *_eventType;
    NSString *_eventData;
    NSDate *_eventTimestamp;                // NOTE: store as unix format timestamp or NSDate and change when send to server?
                                            //    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
}

@property (nonatomic, assign) NSString *eventType;
@property (nonatomic, copy) NSString *eventData;
@property (nonatomic, copy) NSDate *eventTimestamp;

-(id) initWithData:(NSString *)type withData:(NSString *)data withTimestamp:(NSDate *)timestamp;
-(void) saveEventToDisk:(NSString *)fileName;

@end
