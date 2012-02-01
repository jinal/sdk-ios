//
//  PHPublisherMetadataRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/22/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAPIRequest.h"

@interface PHPublisherMetadataRequest : PHAPIRequest{
    NSString *_placement;
}

+(id)requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate;


@property (nonatomic,copy) NSString *placement;

@end
