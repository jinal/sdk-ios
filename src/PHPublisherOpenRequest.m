//
//  PHPublisherOpenRequest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHPublisherOpenRequest.h"
#import "PHConstants.h"
#import "PHStringUtil.h"

@implementation PHPublisherOpenRequest



#pragma mark PHAPIRequest
-(NSString *)urlPath{
    return PH_URL(/v3/publisher/open/);
}

-(NSDictionary*)additionalParameters {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [PHStringUtil phid], @"phid", 
            nil];
}

-(void)didSucceedWithResponse:(NSDictionary *)responseData{
    [PHStringUtil setPhid:[responseData valueForKey:@"phid"]];
    [super didSucceedWithResponse:responseData]; 
}

-(void)dealloc {
    [super dealloc];
    [_phid release];
}
@end
