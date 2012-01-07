//
//  PHPublisherOpenRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PHAPIRequest.h"

@interface PHPublisherOpenRequest : PHAPIRequest{
    NSOperationQueue *prefetchQueue;
}

-(void) downloadPrefetchURLs;
-(void) cancelPrefetchDownload;

-(void) clearPrefetchCache;

@end
