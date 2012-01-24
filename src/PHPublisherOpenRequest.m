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

@interface PHAPIRequest(Private)
-(void)finish;
@end

@implementation PHPublisherOpenRequest

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
        [self.prefetchOperations addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    }
    
    return  self;
}

-(NSString *)urlPath{
    return PH_URL(/v3/publisher/open/);
}

-(NSOperationQueue *)prefetchOperations{
    if (_prefetchOperations == nil) {
        _prefetchOperations = [[NSOperationQueue alloc] init];
        [_prefetchOperations setMaxConcurrentOperationCount:PH_MAX_CONCURRENT_OPERATIONS];
    }
    
    return _prefetchOperations;
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
            [self.prefetchOperations addOperation:urlpo];
            [urlpo release];
        }

        [fileManager release];
    }

    // Don't finish the request before prefetching has completed!
    if ([self.delegate respondsToSelector:@selector(request:didSucceedWithResponse:)]) {
        [self.delegate performSelector:@selector(request:didSucceedWithResponse:) withObject:self withObject:responseData];
    }
}

#pragma mark - Precache URL selectors

-(void) downloadPrefetchURLs{
    
    NSString *cachePlist = [PHURLPrefetchOperation getCachePlistFile];
    if ([[[[NSFileManager alloc] init] autorelease] fileExistsAtPath:cachePlist]){
        
        NSMutableDictionary *prefetchUrlDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:cachePlist] autorelease];
        NSArray *urlArray = (NSArray *)[prefetchUrlDictionary objectForKey:@"precache"];
        for (NSString *urlString in urlArray){
            
            NSURL *url = [NSURL URLWithString:urlString];
            PHURLPrefetchOperation *urlpo = [[PHURLPrefetchOperation alloc] initWithURL:url];
            [self.prefetchOperations addOperation:urlpo];
            [urlpo release];
        }
    }
}

-(void) cancelPrefetchDownload{
    [self.prefetchOperations cancelAllOperations];
}

-(void) clearPrefetchCache{

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
    [self.prefetchOperations removeObserver:self forKeyPath:@"operations"];
    
    [_prefetchOperations release], _prefetchOperations = nil;
    [super dealloc];
}

#pragma mark - NSOperationQueue observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)operation change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"operations"]){
        
        if ([self.prefetchOperations.operations count] == 0){
            if ([self.delegate respondsToSelector:@selector(requestFinishedPrefetching:)]){
                [self.delegate performSelector:@selector(requestFinishedPrefetching:) withObject:self];
            }
            //REQUEST_RELEASE see REQUEST_RETAIN
            [self finish];
        }
    }
}
@end
