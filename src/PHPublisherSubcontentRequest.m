//
//  PHPublisherSubcontentRequest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 5/19/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHPublisherSubContentRequest.h"
#import "PHConstants.h"

@implementation PHPublisherSubContentRequest

@synthesize placement = _placement;
@synthesize source = _source;
@synthesize callback = _callback;

-(NSString *)urlPath{
  return PH_URL(/v3/publisher/content/);
}

-(void)dealloc{
  [_placement release], _placement = nil;
  [_callback release], _callback = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark PHAPIRequest

-(NSDictionary *)additionalParameters{
  return [NSDictionary dictionaryWithObjectsAndKeys:
          self.placement, @"placement_id",
          nil];
}

@end
