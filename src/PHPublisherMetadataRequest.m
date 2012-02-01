//
//  PHPublisherMetadataRequest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/22/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHPublisherMetadataRequest.h"
#import "PHConstants.h"

@interface PHAPIRequest(Private)
-(id)initWithApp:(NSString *)token secret:(NSString *)secret;
@end

@interface PHPublisherMetadataRequest(Private)
-(id)initWithApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate;
@end

@implementation PHPublisherMetadataRequest

+(id)requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate{
    return [[[[self class] alloc] initWithApp:token secret:secret placement:placement delegate:delegate] autorelease];
}

-(id)initWithApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate{
    if ((self = [self initWithApp:token secret:secret])) {
        self.placement = placement;
        self.delegate = delegate;
    }
    
    return self;
}

@synthesize placement = _placement;

-(void)dealloc{
    [_placement release], _placement = nil;
    [super dealloc];
}

#pragma mark - PHAPIRequest

-(NSString *)urlPath{
    return PH_URL(/v3/publisher/content/);
}

-(NSDictionary *)additionalParameters{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.placement, @"placement_id",
            @"1", @"metadata",
            nil];
}

@end
