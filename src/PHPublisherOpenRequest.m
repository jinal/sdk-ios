//
//  PHPublisherOpenRequest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHPublisherOpenRequest.h"
#import "PHConstants.h"

@implementation PHPublisherOpenRequest

-(NSString *)urlPath{
  return PH_URL(/v3/publisher/open/);
}

-(void)processRequestResponse:(NSDictionary *)responseData{
  [self didSucceedWithResponse:nil];
}

@end
