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



#pragma mark PHAPIRequest Override
-(NSString *)urlPath{
    return PH_URL(/v3/publisher/open/);
}

-(NSDictionary*)additionalParameters {
    return ([PHStringUtil phid] ? [NSDictionary dictionaryWithObjectsAndKeys:[PHStringUtil phid], @"phid", nil] : nil);
}


-(void)processRequestResponse:(NSDictionary *)responseData{
    NSDictionary *response = [responseData objectForKey:@"response"];
    NSString *phid = [response objectForKey:@"phid"];
    
    [PHStringUtil setPhid:phid];
    
    [self didSucceedWithResponse:nil];
}

-(void)dealloc {
    [super dealloc];
    [_phid release];
}
@end
