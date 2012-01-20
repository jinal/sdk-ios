//
//  PublisherTrackingViewController.h
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/20/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExampleViewController.h"
#import "PlayHavenSDK.h"

@interface PublisherTrackingViewController : ExampleViewController<PHAPIRequestDelegate>{
    
}

-(IBAction)sendToServerButtonPressed:(id)sender;

@end
