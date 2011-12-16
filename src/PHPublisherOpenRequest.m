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

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024             // 1MB mem cache
                                               diskCapacity:1024*1024*5                     // 5MB disk cache
                                               diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:urlCache];
    //[urlCache release];
/*
    NSString *announcementURL = @"http://media.playhaven.com/content-templates/e690da767f7487e82a072446843e675e97acc5d1/html/announcement.html.gz";
    NSURL  *url = [NSURL URLWithString:announcementURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (urlData)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];  
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, @"announcement.html"];
        [urlData writeToFile:filePath atomically:YES];
    }
    NSString *gowURL = @"http://media.playhaven.com/content-templates/e690da767f7487e82a072446843e675e97acc5d1/html/gow.html.gz";
    url = [NSURL URLWithString:gowURL];
    urlData = [NSData dataWithContentsOfURL:url];
    if (urlData)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];  
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, @"gow.html"];
        [urlData writeToFile:filePath atomically:YES];
    }
*/
}

-(void)didSucceedWithResponse:(NSDictionary *)responseData{
    NSLog(@"%@", responseData);

    NSString *message = [NSString stringWithFormat:@"open response: %@",responseData];    
    NSLog(@"%@", message);

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];  

    // Move file name for caches (SDURLCAChe too) into PHConstants.h - Allows publishers to customize in case of conflicts
    NSString *cacheInfoPath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, @"prefetchCache.plist"];
    NSLog(@"Writing pre-fetch cache plist = %@", cacheInfoPath);
    [responseData writeToFile:cacheInfoPath atomically:YES];
    
    // Check id for what is currently in cache to see if need update

    // Download cache files and store this dictionary off in cache
    NSEnumerator *keyEnum = [responseData keyEnumerator];
    id key;
    while ((key = [keyEnum nextObject]))
    {
        if (![(NSString *)key isEqualToString:@"id"])
        {
            NSString *urlString = [responseData objectForKey:key];
            NSLog(@"Downloading url = %@", urlString);
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if (urlData)
            {
                NSString *filename = [[url path] lastPathComponent];
                NSLog(@"file name = %@", [filename stringByDeletingPathExtension]);
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, [filename stringByDeletingPathExtension]];
                [urlData writeToFile:filePath atomically:YES];
            }
        }
    }

    if ([self.delegate respondsToSelector:@selector(request:didSucceedWithResponse:)]) {
        [self.delegate performSelector:@selector(request:didSucceedWithResponse:) withObject:self withObject:responseData];
    }
}

@end
