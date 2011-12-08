//
//  PHPublisherPromosRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/20/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAPIRequest.h"

@interface PHPublisherPromosRequest : PHAPIRequest {
    
}

+(id)requestForApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate;

-(id)initWithApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate;

@end
