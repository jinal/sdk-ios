//
//  PHURLLoaderTest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "PHURLLoader.h"

#define EXPECTED_HASH @"3L0xlrDOt02UrTDwMSnye05Awwk"
//#define EXPECTED_HASH @"sbiA9ROvCFEPANNFLbq3BK6m_dU-"

@interface PHURLLoaderTest : SenTestCase
@end


@implementation PHURLLoaderTest

-(void)testLoaderParameter{
    PHURLLoader *loader = [[PHURLLoader alloc] init];
    STAssertNoThrow(loader.opensFinalURLOnDevice = NO, @"Couldn't set opensFinalURLOnDevice property!");
}

@end
