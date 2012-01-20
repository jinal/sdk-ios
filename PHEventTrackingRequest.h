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

@interface PHEventTrackingRequest : PHAPIRequest{
    PHEvent *_event;
    NSString *event_queue_hash;
}

@property (nonatomic, copy) PHEvent *event;
@property (nonatomic, copy) NSString *event_queue_hash;

@end
