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
    NSDate *_eventTimestamp;
}

@property (nonatomic, copy) NSString *eventType;    // assign since static?
@property (nonatomic, copy) NSString *eventData;    // assign since static?
@property (nonatomic, copy) NSDate *eventTimestamp;

-(id) initWithData:(NSString *)type withData:(NSString *)data withTimestamp:(NSDate *)timestamp;
-(void) saveEventToDisk:(NSString *)fileName;

@end
