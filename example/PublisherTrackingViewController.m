//
//  PublisherTrackingViewController.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/20/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PublisherTrackingViewController.h"

@implementation PublisherTrackingViewController

-(void)startRequest{
    [super startRequest];
    
    /*
     * Send the current event queue up to the server
     */
    PHEventTrackingRequest *request = [PHEventTrackingRequest requestForApp:@"token" secret:@"secret"];
    request.delegate = self;
    [request send];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    [PHAPIRequest cancelAllRequestsWithDelegate:self];
    [super dealloc];
}

#pragma mark - PHAPIRequestDelegate
-(void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData{
    NSString *message = [NSString stringWithFormat:@"[OK] Success with response: %@",responseData];
    [self addMessage:message];

    [self finishRequest];
}

-(void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error{
    NSString *message = [NSString stringWithFormat:@"[ERROR] Failed with error: Need to make an open request to initialize tracking, %@", error];
    [self addMessage:message];

    [self finishRequest];
}

-(void)requestFinishedPrefetching:(PHAPIRequest *)request{
    [self addMessage:@"Finished prefetching!"];
    [self addElapsedTime];
}

@end
