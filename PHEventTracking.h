//
//  PHEventTracking.h
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/18/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHEvent.h"
#import "PHEventTimeInGame.h"

@interface PHEventTracking : NSObject{

}

+(void) addEvent:(NSObject *)event;

@end
