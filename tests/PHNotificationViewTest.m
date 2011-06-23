//
//  PHNotificationViewTest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "PHNotificationView.h"

@interface PHNotificationViewTest : SenTestCase
@end


@implementation PHNotificationViewTest

-(void)testInstance{
  PHNotificationView *notificationView = [[PHNotificationView alloc]initWithApp:@"" secret:@"" placement:@""];
  STAssertNotNil(notificationView, @"expected notification view instance, got nil");
  STAssertTrue([notificationView respondsToSelector:@selector(refresh)], @"refresh method not present");
}

@end
