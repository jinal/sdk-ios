//
//  PHUrlPrefetchOperation.h
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/6/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHURLPrefetchOperation : NSOperation{
    
    NSURL *prefetchURL;
    NSString *cacheDirectory;
}

@property(retain) NSURL *prefetchURL;
@property(retain) NSString *cacheDirectory;

- (id)initWithURL:(NSURL*)url;

+(NSString *)getCachePlistFile;

@end
