//
//  ExampleViewController.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExampleViewController : UITableViewController {
  NSMutableArray *_messages;
}

-(void)addMessage:(NSString *)message;
-(void)startRequest;

@end
