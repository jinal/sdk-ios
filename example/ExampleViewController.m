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

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    _messages = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc {
  [_messages release], _messages = nil;
  [super dealloc];
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

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem *startButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" 
                                                                  style:UIBarButtonItemStyleBordered 
                                                                 target:self 
                                                                 action:@selector(startRequest)];
  self.navigationItem.rightBarButtonItem = startButton;
  [startButton release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) || (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *message = [_messages objectAtIndex:indexPath.row];
  CGSize size = [message sizeWithFont:LOG_FONT constrainedToSize:CGSizeMake(tableView.frame.size.width-24, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
  return size.height + 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
