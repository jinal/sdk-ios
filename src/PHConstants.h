//
//  PHConstants.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/14/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <UIKit/UIImage.h>

// Constants
#define PH_SDK_VERSION @"1.6.0"

#ifndef PH_BASE_URL
#define PH_BASE_URL @"http://api2.playhaven.com"
#endif

#ifndef PH_CONTENT_ADDRESS
#define PH_CONTENT_ADDRESS @"http://media.playhaven.com"
#endif


// PHContentView notification that a callback is ready for processing
//
#define PHCONTENTVIEW_CALLBACK_NOTIFICATION  @"PHContentViewPHCallbackNotification"


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
// Defines the maximum amount of time that an API request will wait for a 
// response from the server.
#define PH_REQUEST_TIMEOUT 10

// PH_USE_CONTENT_VIEW_RECYCLING
// Recycles content view instances to reduce the number of allocations.
// Behavior of the SDK without this define has not been tested. 
#define PH_USE_CONTENT_VIEW_RECYCLING

// PH_DISMISS_CONTENT_REQUEST_WHEN_BACKGROUNDED
// By default, content requests are dismissed when the app is backgrounded.
// Set PH_DONT_DISMISS_WHEN_BACKGROUNDED as a preprocessor macro to disable this behavior.
#ifndef PH_DONT_DISMISS_WHEN_BACKGROUNDED
#define PH_DISMISS_WHEN_BACKGROUNDED
#endif

// Macros
#define PH_URL(PATH) [PH_BASE_URL stringByAppendingString:@#PATH]
#define PH_URL_FMT(PATH,FMT) [PH_BASE_URL stringByAppendingFormat:@#PATH, FMT]

#ifndef PH_LOG
#define PH_LOG(COMMENT,...) NSLog(@"[PlayHaven-%@] %@",PH_SDK_VERSION, [NSString stringWithFormat:COMMENT,__VA_ARGS__])
#endif

#ifndef PH_NOTE
#define PH_NOTE(COMMENT) NSLog(@"[PlayHaven-%@] %@",PH_SDK_VERSION, COMMENT)
#endif

#define PH_MULTITASKING_SUPPORTED [[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] && [[UIDevice currentDevice] isMultitaskingSupported]

// Errors
typedef enum{
  PHAPIResponseErrorType,
  PHRequestResponseErrorType,
  PHOrientationErrorType,
  PHLoadContextErrorType,
  PHWindowErrorType,
  PHProductRequestErrorType,
} PHErrorType;

NSError *PHCreateError(PHErrorType errorType);


// PHNetworkStatus
// Determines the status of the device's connectivity. Returns:
// 
// 0: No connection
// 1: Cellular data, 3G/EDGE
// 2: WiFi
int PHNetworkStatus(void);


// Caching constant definitions
//
#define PH_PREFETCH_URL_PLIST @"prefetchCache.plist"

#define PH_MAX_CONCURRENT_OPERATIONS    2

#define PH_MAX_SIZE_MEMORY_CACHE        1024*1024          // 1MB mem cache
#define PH_MAX_SIZE_FILESYSTEM_CACHE    1024*1024*10       // 10MB disk cache


// Event Tracking definitions
//
#define PH_MAX_EVENT_QUEUES     5                   // Number of event queues to store on disk. An event queue is
                                                    // started every application start
#define PH_MAX_EVENT_RECORDS    500                 // Maximum number of event records a event queue can hold.
                                                    // Event tracking stops once this is reached
#define PH_MAX_EVENT_RECORDS_SEND_PER_REQUEST   100 // Maximum number of event records that are sent during
                                                    // a PHEventTrackingRequest

//
// Play Haven default images
//
typedef struct{
  int width;
  int height;
  int length;
  char data[];
  
} playHavenImage;

//
// Play Haven default image helper functions
//
UIImage *convertByteDataToUIImage(playHavenImage *phImage);

// Return true if the device has a retina display, false otherwise. Use this to load @2x images
#define IS_RETINA_DISPLAY() [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f

extern const playHavenImage badge_image;
extern const playHavenImage badge_2x_image;
extern const playHavenImage close_image;
extern const playHavenImage close_active_image;

