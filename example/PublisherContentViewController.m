//
//  PublisherContentViewController.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PublisherContentViewController.h"

@implementation PublisherContentViewController
@synthesize placementField = _placementField;
@synthesize request = _request;
@synthesize showsOverlaySwitch;
@synthesize animateSwitch;


-(void)dealloc{
    [PHAPIRequest cancelAllRequestsWithDelegate:self];
    
    [_notificationView release], _notificationView = nil;
    [_placementField release], _placementField = nil;
    [_request release], _request = nil;
    [super dealloc];
}

-(void)startRequest{
    if (self.request == nil) {
        [super startRequest];
        
        [self.placementField resignFirstResponder];
        
        NSString *placement = (![self.placementField.text isEqualToString:@""])? self.placementField.text : @"more_games";
        PHPublisherContentRequest * request = [PHPublisherContentRequest requestForApp:self.token secret:self.secret placement:placement delegate:self];
        [request setShowsOverlayImmediately:[showsOverlaySwitch isOn]];
        [request setAnimated:[animateSwitch isOn]];
        [request send];
        
        [self setRequest:request];

        [self.navigationItem.rightBarButtonItem setTitle:@"Cancel"];
    } else {
        [self addMessage:@"Request canceled!"];
        
        [self.request cancel];
        self.request = nil;
        
        
        [self.navigationItem.rightBarButtonItem setTitle:@"Start"];
    }
}

-(void)finishRequest{
    [super finishRequest];

    //Cleaning up after a completed request
    self.request = nil;
    [self.navigationItem.rightBarButtonItem setTitle:@"Start"];      
}

#pragma mark - PHPublisherContentRequestDelegate
-(void)requestWillGetContent:(PHPublisherContentRequest *)request{
    NSString *message = [NSString stringWithFormat:@"Getting content for placement: %@", request.placement];
    [self addMessage:message];
}

-(void)requestDidGetContent:(PHPublisherContentRequest *)request{
    NSString *message = [NSString stringWithFormat:@"Got content for placement: %@", request.placement];
    [self addMessage:message];
    [self addElapsedTime];
}

-(void)request:(PHPublisherContentRequest *)request contentWillDisplay:(PHContent *)content{
    NSString *message = [NSString stringWithFormat:@"Preparing to display content: %@",content];
    [self addMessage:message];
    
    [self addElapsedTime];
}

-(void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content{
    //This is a good place to clear any notification views attached to this request.
    [_notificationView clear];
  
    NSString *message = [NSString stringWithFormat:@"Displayed content: %@",content];
    [self addMessage:message];
    
    [self addElapsedTime];
}

-(void)requestContentDidDismiss:(PHPublisherContentRequest *)request{
    NSString *message = [NSString stringWithFormat:@"✔ User dismissed request: %@",request];
    [self addMessage:message];

    [self finishRequest];
}

-(void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error{
    NSString *message = [NSString stringWithFormat:@"✖ Failed with error: %@", error];
    [self addMessage:message];
    [self finishRequest];
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
    
    [self startTimers];
    [[PHPublisherContentRequest requestForApp:self.token secret:self.secret placement:@"more_games" delegate:self] preload];
    
  _notificationView = [[PHNotificationView alloc] initWithApp:self.token secret:self.secret placement:@"more_games"];
  _notificationView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
}

-(void)viewDidUnload{
    [self setPlacementField:nil];
  [super viewDidUnload];
  [_notificationView removeFromSuperview];
  [_notificationView release], _notificationView = nil;
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self.view addSubview:_notificationView];
  [_notificationView setCenter:CGPointMake(self.view.frame.size.width - 22, 19)];
  [_notificationView refresh];
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [_notificationView removeFromSuperview];
}

@end
