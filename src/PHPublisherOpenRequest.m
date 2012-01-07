//
//  PHPublisherOpenRequest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHPublisherOpenRequest.h"
#import "PHConstants.h"
#import "SDURLCache.h"
#import "PHUrlPrefetchOperation.h"
#import "SDURLCache.h"

@implementation PHPublisherOpenRequest

-(NSString *)urlPath{
  return PH_URL(/v3/publisher/open/);
}

+(void)initialize{
    if  (self == [PHPublisherOpenRequest class]){
        // Initializes pre-fetching and webview caching
        SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:PH_MAX_SIZE_MEMORY_CACHE
                                                        diskCapacity:PH_MAX_SIZE_FILESYSTEM_CACHE
                                                        diskPath:[SDURLCache defaultCachePath]];
        [NSURLCache setSharedURLCache:urlCache];
        //[[NSURLCache sharedURLCache] removeAllCachedResponses];
        [urlCache release];
    }
}

-(id)init{
    self = [super init];
    if (self) {
        prefetchQueue = [[NSOperationQueue alloc] init];
        [prefetchQueue setMaxConcurrentOperationCount:PH_MAX_CONCURRENT_OPERATIONS];
    }
    
    return  self;
}

-(void)prefetchUrls:(NSDictionary *)urls directory:(NSString *)cacheDirectory{
    
    NSArray *urlArray = (NSArray *)[urls objectForKey:@"precache"];
    for (NSString *urlString in urlArray){

        NSURL *url = [NSURL URLWithString:urlString];
        PHUrlPrefetchOperation *urlpo = [[PHUrlPrefetchOperation alloc] initWithURL:url];
        [prefetchQueue addOperation:urlpo];
        [urlpo release];
    }
}

#pragma mark - PHAPIRequest response delegate

-(void)didSucceedWithResponse:(NSDictionary *)responseData{

    if ([responseData count] > 0){

        NSString *cachePlist = [PHUrlPrefetchOperation getCachePlistFile];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:cachePlist]){

            [fileManager removeItemAtPath:cachePlist error:NULL];
        }
        [responseData writeToFile:cachePlist atomically:YES];
        [self prefetchUrls:responseData directory:cachePlist];
        [fileManager release];
    }

    [super didSucceedWithResponse:responseData];
}

#pragma mark - Download precache URL selectors

-(void) downloadPrefetchURLs{
    
    NSString *cachePlist = [PHUrlPrefetchOperation getCachePlistFile];
    NSMutableDictionary *prefetchUrlDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:cachePlist] autorelease];
    NSArray *urlArray = (NSArray *)[prefetchUrlDictionary objectForKey:@"precache"];
    for (NSString *urlString in urlArray){
        
        NSURL *url = [NSURL URLWithString:urlString];
        PHUrlPrefetchOperation *urlpo = [[PHUrlPrefetchOperation alloc] initWithURL:url];
        [prefetchQueue addOperation:urlpo];
        [urlpo release];
    }
}

-(void) cancelPrefetchDownload{
    [prefetchQueue cancelAllOperations];
}

-(void) clearPrefetchCache{

    NSString *cachePlist = [PHUrlPrefetchOperation getCachePlistFile];
    NSMutableDictionary *prefetchUrlDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:cachePlist] autorelease];
    NSArray *urlArray = (NSArray *)[prefetchUrlDictionary objectForKey:@"precache"];
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    for (NSString *urlString in urlArray){

        NSURL *url = [NSURL URLWithString:urlString];
        NSString *cacheKey = [SDURLCache cacheKeyForURL:url];
        NSString *cacheFilePath = [[SDURLCache defaultCachePath] stringByAppendingPathComponent:cacheKey];
        if ([fileManager fileExistsAtPath:cacheFilePath]){
            
            [fileManager removeItemAtPath:cacheFilePath error:NULL];
        }
    }
}

#pragma mark - NSObject

- (void)dealloc{
    
    [prefetchQueue release], prefetchQueue = nil;
    [super dealloc];
}

@end
