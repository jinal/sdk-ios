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
@synthesize tableView = _tableView;
@synthesize token = _token;
@synthesize secret = _secret;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self){
    _messages = [[NSMutableArray alloc] init];    
  }
  return self;
}

- (void)dealloc {
    [_messages release], _messages = nil;
    [_tableView release], _tableView = nil;
    [_token release], _token = nil;
    [_secret release], _secret = nil;
    [_startRequestDate release], _startRequestDate = nil;
    [_deltaRequestDate release], _deltaRequestDate = nil;
     
    [super dealloc];
}

#pragma mark -
-(void)addMessage:(NSString *)message{
  [_messages addObject:message];
  [self.tableView reloadData];
}

-(void)addElapsedTime{
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSTimeInterval totalDelta = [now timeIntervalSinceDate:_startRequestDate];
    NSTimeInterval intervalDelta =[now timeIntervalSinceDate:_deltaRequestDate];
    NSString *message = [NSString stringWithFormat:@"🕑 %f secs total (+ %f secs)", totalDelta, intervalDelta];
    [self addMessage:message];
    
    [_deltaRequestDate release], _deltaRequestDate = now;
}

-(void)startRequest{
    [_messages removeAllObjects];
    [self addMessage:@"Started request!"];
    
    [_startRequestDate release], _startRequestDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    [_deltaRequestDate release], _deltaRequestDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
}

-(void)finishRequest{
    [self addElapsedTime];
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
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) || (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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

- (void)viewDidUnload {
  [self setTableView:nil];
  [self setTableView:nil];
  [super viewDidUnload];
}
@end
