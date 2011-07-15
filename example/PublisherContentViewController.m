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

-(void)dealloc{
  [_notificationView release], _notificationView = nil;
  [super dealloc];
}

-(void)startRequest{
  [super startRequest];
  PHPublisherContentRequest * request = [PHPublisherContentRequest requestForApp:PH_TOKEN secret:PH_SECRET placement:@"more_games" delegate:self];
  
  request.showsOverlayImmediately = YES;
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
  //This is a good place to clear any notification views attached to this request.
  [_notificationView clear];
  
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

-(void)request:(PHPublisherContentRequest *)request unlockedReward:(PHReward *)reward{
  NSString *message = [NSString stringWithFormat:@"☆ Unlocked reward: %dx %@", reward.quantity, reward.name];
  [self addMessage:message]; 
}

#pragma - Notifications
/*
 * Refresh your notification view from the server each time it appears. 
 * This way you can be sure the type and value of the notification is most
 * likely to match up to the content unit that will appear.
 */

-(void)viewDidLoad{
  [super viewDidLoad];
  _notificationView = [[PHNotificationView alloc] initWithApp:PH_TOKEN secret:PH_SECRET placement:@"more_games"];
  _notificationView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  _notificationView.center = CGPointMake(self.view.frame.size.width - 22, 19);
}

-(void)viewDidUnload{
  [super viewDidUnload];
  [_notificationView removeFromSuperview];
  [_notificationView release], _notificationView = nil;
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self.view addSubview:_notificationView];
  [_notificationView refresh];
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [_notificationView removeFromSuperview];
}

@end
