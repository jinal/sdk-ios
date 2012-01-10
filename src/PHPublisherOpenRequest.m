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
#import "PHURLPrefetchOperation.h"

@implementation PHPublisherOpenRequest

-(NSString *)urlPath{
  return PH_URL(/v3/publisher/open/);
}

+(NSOperationQueue *)prefetchOperations{
    static NSOperationQueue *prefetchQueue = nil;

    if (prefetchQueue == nil) {
        prefetchQueue = [[NSOperationQueue alloc] init];
        [prefetchQueue setMaxConcurrentOperationCount:PH_MAX_CONCURRENT_OPERATIONS];
    }

    return prefetchQueue;
}

+(NSMutableSet *)allPrefetchs{
    static NSMutableSet *allPrefetchs = nil;
    
    if (allPrefetchs == nil) {
        allPrefetchs = [[NSMutableSet alloc] init];
    }
    
    return allPrefetchs;
}


+(void)initialize{

    if  (self == [PHPublisherOpenRequest class]){
        // Initializes pre-fetching and webview caching
        SDURLCachePH *urlCache = [[SDURLCachePH alloc] initWithMemoryCapacity:PH_MAX_SIZE_MEMORY_CACHE
                                                        diskCapacity:PH_MAX_SIZE_FILESYSTEM_CACHE
                                                        diskPath:[SDURLCachePH defaultCachePath]];
        [NSURLCache setSharedURLCache:urlCache];
        [urlCache release];
    }
}

-(id)init{
    self = [super init];
    if (self) {
        [[PHPublisherOpenRequest allPrefetchs] addObject:self];
        [[PHPublisherOpenRequest prefetchOperations] addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    }
    
    return  self;
}

#pragma mark - PHAPIRequest response delegate

-(void)didSucceedWithResponse:(NSDictionary *)responseData{

    if ([responseData count] > 0){

        NSString *cachePlist = [PHURLPrefetchOperation getCachePlistFile];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:cachePlist]){

            [fileManager removeItemAtPath:cachePlist error:NULL];
        }
        [responseData writeToFile:cachePlist atomically:YES];

        NSArray *urlArray = (NSArray *)[responseData objectForKey:@"precache"];
        for (NSString *urlString in urlArray){
            
            NSURL *url = [NSURL URLWithString:urlString];
            PHURLPrefetchOperation *urlpo = [[PHURLPrefetchOperation alloc] initWithURL:url];
            [[PHPublisherOpenRequest prefetchOperations] addOperation:urlpo];
            [urlpo release];
        }

        [fileManager release];
    }

    [super didSucceedWithResponse:responseData];
}

#pragma mark - Precache URL selectors

+(void) downloadPrefetchURLs{
    
    NSString *cachePlist = [PHURLPrefetchOperation getCachePlistFile];
    NSMutableDictionary *prefetchUrlDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:cachePlist] autorelease];
    NSArray *urlArray = (NSArray *)[prefetchUrlDictionary objectForKey:@"precache"];
    for (NSString *urlString in urlArray){
        
        NSURL *url = [NSURL URLWithString:urlString];
        PHURLPrefetchOperation *urlpo = [[PHURLPrefetchOperation alloc] initWithURL:url];
        [[PHPublisherOpenRequest prefetchOperations] addOperation:urlpo];
        [urlpo release];
    }
}

+(void) cancelPrefetchDownload{
    [[PHPublisherOpenRequest prefetchOperations] cancelAllOperations];
}

+(void) clearPrefetchCache{

    NSString *cachePlist = [PHURLPrefetchOperation getCachePlistFile];
    NSMutableDictionary *prefetchUrlDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:cachePlist] autorelease];
    NSArray *urlArray = (NSArray *)[prefetchUrlDictionary objectForKey:@"precache"];
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    for (NSString *urlString in urlArray){

        NSURL *url = [NSURL URLWithString:urlString];
        NSString *cacheKey = [SDURLCachePH cacheKeyForURL:url];
        NSString *cacheFilePath = [[SDURLCachePH defaultCachePath] stringByAppendingPathComponent:cacheKey];
        if ([fileManager fileExistsAtPath:cacheFilePath]){
            
            [fileManager removeItemAtPath:cacheFilePath error:NULL];
        }
    }
}

#pragma mark - NSObject

- (void)dealloc{
  
    [super dealloc];
}

#pragma mark - NSOperationQueue observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)operation change:(NSDictionary *)change context:(void *)context{
    
    if (operation == [PHPublisherOpenRequest prefetchOperations] && [keyPath isEqualToString:@"operations"]){
        
        if ([[PHPublisherOpenRequest prefetchOperations].operations count] == 0){

            NSLog(@"queue has completed");

            [[PHPublisherOpenRequest prefetchOperations] release];

            //REQUEST_RELEASE see REQUEST_RETAIN
            [[PHPublisherOpenRequest allPrefetchs] removeObject:self];
        }
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:operation change:change context:context];
    }
}
@end
