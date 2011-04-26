//
//  PublisherOpenViewController.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PublisherOpenViewController.h"
#import "Constants.h"

@implementation PublisherOpenViewController

-(void)startRequest{
  [super startRequest];
  
  PHPublisherOpenRequest * request = [PHPublisherOpenRequest requestForApp:PH_TOKEN secret:PH_SECRET];
  request.delegate = self;
  
  [request send];
}

#pragma mark - PHAPIRequestDelegate
-(void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData{
  NSString *message = [NSString stringWithFormat:@"✔ Success with response: %@",responseData];
  [self addMessage:message];
}

-(void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error{
  NSString *message = [NSString stringWithFormat:@"✖ Failed with error: %@", error];
  [self addMessage:message];  
}

@end
