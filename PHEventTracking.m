//
//  PHEventTracking.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHEventTracking.h"

static NSString *const PHEventTrackingMaximumEventQueuesKey = @"max_event_queues";
static NSString *const PHEventTrackingMaximumEventRecordsKey = @"max_event_records";


// During initialize a new hash will be made from the timestamp (First event? should be appstart event
// or use a timestamp created here for the queue?)
// Create a new PHEventTimeInGame in this initialize call

@implementation PHEventTracking

#pragma mark - Static Methods

+(void)initialize{
    if  (self == [PHEventTracking class]){
        
        PHEventTimeInGame *appStartedEvent = [PHEventTimeInGame createPHEventApplicationDidStart];
        [PHEventTracking addEvent:appStartedEvent];
    }
}


#pragma mark PHEventTracking (event tracking)

+(void) addEvent:(NSObject *)event{
    
}

#pragma mark NSObject

- (void)dealloc{

    [super dealloc];
}

@end
