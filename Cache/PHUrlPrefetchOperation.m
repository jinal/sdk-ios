//
//  PHUrlPrefetchOperation.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/6/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHUrlPrefetchOperation.h"
#import "PHConstants.h"
#import "SDURLCache.h"

@implementation PHUrlPrefetchOperation

@synthesize prefetchURL;
@synthesize cacheDirectory;

+(NSString *)getCachePlistFile{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@", cacheDirectory, PH_PREFETCH_URL_PLIST];
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

    if (cacheDirectory == nil){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cacheDirectory = [paths objectAtIndex:0];
    }

    NSData *urlData = [NSData dataWithContentsOfURL:prefetchURL];
    if (urlData){

        NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
        NSString *cacheKey = [SDURLCache cacheKeyForURL:prefetchURL];
        NSString *cacheFilePath = [[SDURLCache defaultCachePath] stringByAppendingPathComponent:cacheKey];
        if ([fileManager fileExistsAtPath:cacheFilePath]){
            
            [fileManager removeItemAtPath:cacheFilePath error:NULL];
        }
        [urlData writeToFile:cacheFilePath atomically:YES];
    }
}

@end
