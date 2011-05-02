//
//  RootViewController.m
//  example
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "RootViewController.h"
#import "PublisherOpenViewController.h"
#import "PublisherPromosViewController.h"
#import "PublisherContentViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"PlayHaven";
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
      cell.textLabel.text = @"Tokens";
      cell.detailTextLabel.text = @"/publisher/tokens/";
      break;
    case 2:
      cell.textLabel.text = @"Content";
      cell.detailTextLabel.text = @"/publisher/content/";
      break;
    default:
      break;
  }
  
  return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert)
 {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) {
    PublisherOpenViewController *controller = [[PublisherOpenViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.title = @"Open";
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
  } else if (indexPath.row == 1){
    PublisherPromosViewController *controller = [[PublisherPromosViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.title = @"Tokens";
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
  } else if (indexPath.row == 2){
    PublisherContentViewController *controller = [[PublisherContentViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.title = @"Content";
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
  }
  
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}

- (void)dealloc
{
  [super dealloc];
}

@end
