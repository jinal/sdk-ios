//
//  PublisherContentViewController.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExampleViewController.h"
#import "PlayHavenSDK.h"

@interface PublisherContentViewController : ExampleViewController<PHPublisherContentRequestDelegate> {
    PHNotificationView *_notificationView;
    UITextField *_placementField;
    
    PHPublisherContentRequest *_request;
}

@property (nonatomic, retain) IBOutlet UITextField *placementField;
@property (nonatomic, retain) PHPublisherContentRequest *request;

@end
