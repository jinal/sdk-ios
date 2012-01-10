//
//  PublisherOpenViewController.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PublisherOpenViewController.h"

@implementation PublisherOpenViewController

-(void)startRequest{
  [super startRequest];
  
  /*
   * This is an alternate implementation which allows you you get response 
   * data from API requests. This isn't necessary for most developers.
   */
    
  PHPublisherOpenRequest * request = [PHPublisherOpenRequest requestForApp:self.token secret:self.secret];
  request.delegate = self;
  [request send];
}

-(void)dealloc{
    [PHAPIRequest cancelAllRequestsWithDelegate:self];
    [super dealloc];
}

#pragma mark - PHAPIRequestDelegate
-(void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData{
    NSString *message = [NSString stringWithFormat:@"✔ Success with response: %@",responseData];
    [self addMessage:message];

    [self finishRequest];
}

-(void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error{
    NSString *message = [NSString stringWithFormat:@"✖ Failed with error: %@", error];
    [self addMessage:message];
    
    [self finishRequest];
}

@end
