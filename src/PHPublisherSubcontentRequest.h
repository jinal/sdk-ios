//
//  PHPublisherSubcontentRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 5/19/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAPIRequest.h"
@class PHContentView;

@interface PHPublisherSubContentRequest : PHAPIRequest {
    PHContentView *_source;
    NSString *_callback;
}

@property (nonatomic, assign) PHContentView *source;
@property (nonatomic, copy) NSString *callback;

@end
