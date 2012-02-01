//
//  WWURLConnection.h
//  WaterWorks
//
//  Created by Jesus Fernandez on 1/31/12.
//

#import <Foundation/Foundation.h>

@interface WWURLConnection : NSURLConnection

+(WWURLConnection *)connectionWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate, NSURLConnectionDataDelegate>)delegate;

+(void)setResponse:(NSData *)response forURL:(NSURL *)url;
+(void)setResponsesFromFileNamed:(NSString *)fileName;
+(NSData *)bestResponseForURL:(NSURL *)url;
+(void)clearAllResponses;

@property (nonatomic, assign) id<NSURLConnectionDelegate, NSURLConnectionDataDelegate> delegate;
@property (nonatomic, retain) NSURLRequest *request;

@end
