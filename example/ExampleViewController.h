//
//  ExampleViewController.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExampleViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_messages;
    UITableView *_tableView;
    
    NSString *_token;
    NSString *_secret;
    NSDate *_startRequestDate;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *secret;

-(void)addMessage:(NSString *)message;
-(void)addElapsedTime;

-(void)startRequest;
-(void)finishRequest;

@end
