//
//  RootViewController.h
//  example
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
    
    UITextField *tokenField;
    UITextField *secretField;
}

@property (nonatomic, retain) IBOutlet UITextField *tokenField;
@property (nonatomic, retain) IBOutlet UITextField *secretField;

-(void)touchedToggleStatusBar:(id)sender;

@end
