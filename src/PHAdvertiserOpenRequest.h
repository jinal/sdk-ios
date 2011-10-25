//
//  PHAdvertiserOpenRequest.h
//  playhaven-sdk-ios
//
//  Created by Sam Stewart on 10/17/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHAPIRequest.h"

@interface PHAdvertiserOpenRequest : PHAPIRequest{
    BOOL _isNewDevice;
}
@property (assign) BOOL isNewDevice;
@end
