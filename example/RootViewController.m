//
//  RootViewController.m
//  example
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "RootViewController.h"
#import "PublisherOpenViewController.h"
#import "PublisherContentViewController.h"

@implementation RootViewController

- (void)dealloc {
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"PlayHaven";
  
  UIBarButtonItem *toggleButton = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStyleBordered target:self action:@selector(touchedToggleStatusBar:)];
  self.navigationItem.rightBarButtonItem = toggleButton;
  [toggleButton release];
}

-(void)touchedToggleStatusBar:(id)sender{
  BOOL statusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
  
  if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
    [[UIApplication sharedApplication] setStatusBarHidden:!statusBarHidden withAnimation:UIStatusBarAnimationSlide];
  } else {
    [[UIApplication sharedApplication] setStatusBarHidden:!statusBarHidden animated:YES];    
  }
  
  [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
  [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
  switch (indexPath.row) {
    case 0:
      cell.textLabel.text = @"Open";
      cell.detailTextLabel.text = @"/publisher/open/";
      break;
    case 1:
      cell.textLabel.text = @"Content";
      cell.detailTextLabel.text = @"/publisher/content/";
      break;
    default:
      break;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    PublisherOpenViewController *controller = [[PublisherOpenViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.title = @"Open";
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
  } else if (indexPath.row == 1){
    PublisherContentViewController *controller = [[PublisherContentViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.title = @"Content";
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
  }
  
}

@end
