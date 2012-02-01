//
//  PHURLLoader.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 2/9/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PHURLLoader;
@protocol PHURLLoaderDelegate<NSObject>
@optional
-(void)loaderFinished:(PHURLLoader *)loader;
-(void)loaderFailed:(PHURLLoader *)loader;
@end


@interface PHURLLoader : NSObject {
    id <PHURLLoaderDelegate> _delegate;
    NSURLConnection *_connection;
    NSURL *_targetURL;
    NSInteger _totalRedirects;
    BOOL _opensFinalURLOnDevice;
    id _context;
}


+(void)invalidateAllLoadersWithDelegate:(id <PHURLLoaderDelegate>) delegate;
+(PHURLLoader *)openDeviceURL:(NSString*)url;

@property (nonatomic, assign) id <PHURLLoaderDelegate> delegate;
@property (nonatomic, retain) NSURL *targetURL;
@property (nonatomic, assign) BOOL opensFinalURLOnDevice;
@property (nonatomic, retain) id context;

-(void)open;
-(void)invalidate;
@end
