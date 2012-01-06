//
//  PHUrlPrefetchOperation.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/6/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHUrlPrefetchOperation.h"
#import "PHConstants.h"

@implementation PHUrlPrefetchOperation

@synthesize prefetchURL;
@synthesize cacheDirectory;

- (id)initWithURL:(NSURL*)url{

    if (![super init]) return nil;
    [self setPrefetchURL:url];
    return self;
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

        // NOTE: Make the filename the URL hash value so can find eay in SDURLCache when looking for it.
        // Same when do content URL. See loadTemplate in PHContentView.m
        NSString *filename = [[prefetchURL path] lastPathComponent];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, [filename stringByDeletingPathExtension]];
        [urlData writeToFile:filePath atomically:YES];
    }
}

@end
