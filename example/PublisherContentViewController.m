//
//  PublisherContentViewController.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PublisherContentViewController.h"
#import "Constants.h"

@implementation PublisherContentViewController

-(void)startRequest{
  [super startRequest];
  
  PHPublisherContentRequest * request = [PHPublisherContentRequest requestForApp:PH_TOKEN secret:PH_SECRET];
  request.placement = @"placement_id";
  request.delegate = self;
  
  [request send];
}

#pragma mark - PHPublisherContentRequestDelegate
-(void)requestWillGetContent:(PHPublisherContentRequest *)request{
  [self addMessage:@"Starting content request..."];
}

-(void)request:(PHPublisherContentRequest *)request contentWillDisplay:(PHContent *)content{
  NSString *message = [NSString stringWithFormat:@"Recieved content: %@, preparing for display",content];
  [self addMessage:message];
}

-(void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content{
  NSString *message = [NSString stringWithFormat:@"Displayed content: %@",content];
  [self addMessage:message];
}

-(void)requestContentDidDismiss:(PHPublisherContentRequest *)request{
  NSString *message = [NSString stringWithFormat:@"✔ User dismissed request: %@",request];
  [self addMessage:message];
}

-(void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error{
  NSString *message = [NSString stringWithFormat:@"✖ Failed with error: %@", error];
  [self addMessage:message];  
}

-(void)request:(PHPublisherContentRequest *)request contentDidFailWithError:(NSError *)error{
  NSString *message = [NSString stringWithFormat:@"✖ Content failed with error: %@", error];
  [self addMessage:message];  
}



@end
