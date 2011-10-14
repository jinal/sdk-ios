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

@interface RootViewController(Private)
-(void)loadTokenAndSecretFromDefaults;
-(void)saveTokenAndSecretToDefaults;
@end

@implementation RootViewController
@synthesize tokenField;
@synthesize secretField;

- (void)dealloc {
  [tokenField release];
  [secretField release];
  [super dealloc];
}

#pragma mark -
#pragma mark Private

-(void)loadTokenAndSecretFromDefaults{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  self.tokenField.text = [defaults valueForKey:@"ExampleToken"];
  self.secretField.text = [defaults valueForKey:@"ExampleSecret"];
}

-(void)saveTokenAndSecretToDefaults{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  [defaults setValue:self.tokenField.text forKey:@"ExampleToken"];
  [defaults setValue:self.secretField.text forKey:@"ExampleSecret"];
  
  [defaults synchronize];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"PlayHaven";
  [self loadTokenAndSecretFromDefaults];
  
  
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
  if ( !( [self.tokenField.text isEqualToString:@""] || [self.secretField.text isEqualToString:@""] ) ) {
    [self saveTokenAndSecretToDefaults];
    if (indexPath.row == 0) {
      PublisherOpenViewController *controller = [[PublisherOpenViewController alloc] initWithNibName:@"ExampleViewController" bundle:nil];
      controller.title = @"Open";
      controller.token = self.tokenField.text;
      controller.secret = self.secretField.text;
      [self.navigationController pushViewController:controller animated:YES];
      [controller release];
    } else if (indexPath.row == 1){
      PublisherContentViewController *controller = [[PublisherContentViewController alloc] initWithNibName:@"PublisherContentViewController" bundle:nil];
      controller.title = @"Content";
      controller.token = self.tokenField.text;
      controller.secret = self.secretField.text;
      [self.navigationController pushViewController:controller animated:YES];
      [controller release];
    } 
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Credentials" message:@"You must supply a PlayHaven API token and secret to use this app. To get a token and secret, please visit http://playhaven.com on your computer and sign up." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
  
}

- (void)viewDidUnload {
  [self setTokenField:nil];
  [self setSecretField:nil];
  [super viewDidUnload];
}
@end
