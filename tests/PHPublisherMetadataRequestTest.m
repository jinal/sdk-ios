//
//  PHPublisherMetadataRequestTest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "PHPublisherMetadataRequest.h"

@interface PHPublisherMetadataRequestTest : SenTestCase
@end


@implementation PHPublisherMetadataRequestTest

-(void)testInstance{
    PHPublisherMetadataRequest *request = [PHPublisherMetadataRequest requestForApp:@"" secret:@"" placement:@"" delegate:self];
    STAssertNotNil(request, @"expected request instance, got nil");
}

@end
