//
//  PHPublisherTokensRequest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/20/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHPublisherTokensRequest.h"
#import "PHConstants.h"

@implementation PHPublisherTokensRequest

+(id)requestForApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate{
  return [[[[self class] alloc] initWithApp:token secret:secret delegate:delegate] autorelease];
}

-(id)initWithApp:(NSString *)token secret:(NSString *)secret delegate:(id)delegate{
  if ((self = [self initWithApp:token secret:secret])) {
    self.delegate = delegate;
  }
  
  return self;
}

-(NSString *)urlPath{
  return PH_URL(/v3/publisher/tokens/);
}

@end
