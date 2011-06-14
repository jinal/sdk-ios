//
//  ExampleViewController.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "ExampleViewController.h"

#define LOG_FONT [UIFont systemFontOfSize:13]

@implementation ExampleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
    _messages = [[NSMutableArray alloc] init];
    
  }
  return self;
}

- (void)dealloc
{
  [_messages release], _messages = nil;
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
-(void)addMessage:(NSString *)message{
  [_messages addObject:message];
  [self.tableView reloadData];
}

-(void)startRequest{
  [_messages removeAllObjects];
  [self addMessage:@"Started request!"];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIBarButtonItem *startButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" 
                                                                  style:UIBarButtonItemStyleBordered 
                                                                 target:self 
                                                                 action:@selector(startRequest)];
  self.navigationItem.rightBarButtonItem = startButton;
  [startButton release];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *message = [_messages objectAtIndex:indexPath.row];
  CGSize size = [message sizeWithFont:LOG_FONT constrainedToSize:CGSizeMake(tableView.frame.size.width-24, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
  NSLog(@"Row %d height %f for width %f", indexPath.row, size.height, tableView.frame.size.width);
  return size.height + 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = LOG_FONT;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  NSString *message = [_messages objectAtIndex:indexPath.row];
  cell.textLabel.text = message;
  return cell;
}

@end
