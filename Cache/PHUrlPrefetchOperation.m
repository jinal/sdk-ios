//
//  PHUrlPrefetchOperation.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/6/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHURLPrefetchOperation.h"
#import "PHConstants.h"
#import "SDURLCache.h"

@implementation PHURLPrefetchOperation

@synthesize prefetchURL;
@synthesize cacheDirectory;

+(NSString *)getCachePlistFile{
    
    return [[SDURLCachePH defaultCachePath] stringByAppendingPathComponent:PH_PREFETCH_URL_PLIST];
}

- (id)initWithURL:(NSURL*)url{

    if ((self = [super init])) {
        [self setPrefetchURL:url];
    }
    
    return  self;
}

- (void)dealloc{

    [prefetchURL release], prefetchURL = nil;
    [super dealloc];
}

- (void)main{

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    if (cacheDirectory == nil){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cacheDirectory = [paths objectAtIndex:0];
    }

    NSData *urlData = [NSData dataWithContentsOfURL:prefetchURL];
    if (urlData){

        NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
        NSString *cacheKey = [SDURLCachePH cacheKeyForURL:prefetchURL];
        NSString *cacheFilePath = [[SDURLCachePH defaultCachePath] stringByAppendingPathComponent:cacheKey];
        if ([fileManager fileExistsAtPath:cacheFilePath]){
            
            [fileManager removeItemAtPath:cacheFilePath error:NULL];
        }
        [urlData writeToFile:cacheFilePath atomically:YES];
    }

    [pool drain];
}

@end
