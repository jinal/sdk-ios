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
#import "SBJsonParser.h"

static BOOL initialized = NO;

@implementation PHPublisherOpenRequest

-(NSString *)urlPath{
  return PH_URL(/v3/publisher/open/);
}

+(void)phCacheInitialize
{
    if (initialized)
        return;

    initialized = YES;
    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:0//1024*1024          // 1MB mem cache
                                               diskCapacity:1024*1024*10                    // 10MB disk cache
                                               diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:urlCache];
    //[[NSURLCache sharedURLCache] removeAllCachedResponses];
    [urlCache release];
}

-(void)storePrefetchUrls:(NSDictionary *)urls directory:(NSString *)cacheDirectory
{
    NSEnumerator *keyEnum = [urls keyEnumerator];
    id key;
    while ((key = [keyEnum nextObject])){

        if ([(NSString *)key isEqualToString:@"precache"])
            return;
        if (![(NSString *)key isEqualToString:@"id"]){
            
            NSString *urlString = [urls objectForKey:key];
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if (urlData){

                NSString *filename = [[url path] lastPathComponent];
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, [filename stringByDeletingPathExtension]];
                [urlData writeToFile:filePath atomically:YES];
            }
        }
    }
}

-(void)didSucceedWithResponse:(NSDictionary *)responseData{

    if ([responseData count] > 0){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        NSString *cacheInfoPath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, @"prefetchCache.plist"];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if (![fileManager fileExistsAtPath:cacheInfoPath]){
            
            [responseData writeToFile:cacheInfoPath atomically:YES];
            [self storePrefetchUrls:responseData directory:cacheDirectory];
        }
        else{

            NSDictionary *localPrefetchInfo = [[NSDictionary alloc] initWithContentsOfFile:cacheInfoPath];
            NSString *localId = [localPrefetchInfo objectForKey:@"id"];
            NSString *networkId = [responseData objectForKey:@"id"];
            if (![localId isEqualToString:networkId])
                [self storePrefetchUrls:responseData directory:cacheDirectory];
        }
        [fileManager release];
    }

    [super didSucceedWithResponse:responseData];
}

@end
