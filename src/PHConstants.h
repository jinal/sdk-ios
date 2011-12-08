//
//  PHConstants.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/14/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

// Constants
#define PH_SDK_VERSION @"1.3.10"

#ifndef PH_BASE_URL
#define PH_BASE_URL @"http://api2.playhaven.com"
#endif


// PH_DISPATCH_PROTOCOL_VERSION
// Defines characteristics of the requests that get sent from content units to
// native code. See content-templates:src/js/playhaven.js for template impl.
//
//   1: GET request with dispatch parameter keys and values in query string
//   2: GET request with dispatch parameters encoded as a single JSON string 
//      in query string. Rewards support requires this setting.
//   3: Unknown dispatches are ignored instead of throwing an error
// * 4: ph://launch dispatches no longer create native spinner views
#define PH_DISPATCH_PROTOCOL_VERSION 4

// PH_REQUEST_TIMEOUT
#define PH_REQUEST_TIMEOUT 10

// Macros
#define PH_URL(PATH) [PH_BASE_URL stringByAppendingString:@#PATH]
#define PH_URL_FMT(PATH,FMT) [PH_BASE_URL stringByAppendingFormat:@#PATH, FMT]

#define PH_LOG(COMMENT,...) NSLog(@"[PlayHaven-%@] %@",PH_SDK_VERSION, [NSString stringWithFormat:COMMENT,__VA_ARGS__])

#define PH_NOTE(COMMENT) NSLog(@"[PlayHaven-%@] %@",PH_SDK_VERSION, COMMENT)

// Errors
typedef enum{
  PHAPIResponseErrorType,
  PHRequestResponseErrorType,
  PHOrientationErrorType,
  PHLoadContextErrorType,
  PHWindowErrorType
} PHErrorType;

NSError *PHCreateError(PHErrorType errorType);


// PHNetworkStatus
// Determines the status of the device's connectivity. Returns:
// 
// 0: No connection
// 1: Cellular data, 3G/EDGE
// 2: WiFi
int PHNetworkStatus();
