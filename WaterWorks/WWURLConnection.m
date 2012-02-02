//
//  WWURLConnection.m
//  WaterWorks
//
//  Created by Jesus Fernandez on 1/31/12.
//

#import "WWURLConnection.h"
#import "WWURLMatching.h"
#include <stdio.h>
NSString *readLineAsNSString(FILE *file);

NSString *readLineAsNSString(FILE *file)
{
    char buffer[4096];
    
    // tune this capacity to your liking -- larger buffer sizes will be faster, but
    // use more memory
    NSMutableString *result = [NSMutableString stringWithCapacity:256];
    
    // Read up to 4095 non-newline characters
    int charsRead;
    do
    {
        if(fgets(buffer, 4095, file) != NULL)
            [result appendFormat:@"%s", buffer];
        else
            break;
    } while(charsRead == 4095);
    
    return result;
}

@protocol WWURLResponse <NSObject>
-(NSData *)data;
@end

@interface WWURLMemoryResponse : NSObject<WWURLResponse> 
@property (nonatomic, retain) NSData *data;
@end

@implementation WWURLMemoryResponse

@synthesize data = _data;
-(void)dealloc{
    [_data release], _data = nil;
    [super dealloc];
}

@end


@interface WWURLFileResponse : NSObject<WWURLResponse> 
@property (nonatomic, copy) NSString *filePath;
@end

@implementation WWURLFileResponse

@synthesize filePath = _filePath;

-(NSData *)data{
    return [NSData dataWithContentsOfFile:self.filePath];
}

-(void)dealloc{
    [_filePath release], _filePath = nil;
    [super dealloc];
}
@end


@interface WWURLConnection(Private)
+(NSMutableDictionary *)allResponses;
+(NSData *)getResponseForURL:(NSURL *)url;
-(void)startInBackground;
@end

@implementation WWURLConnection

#pragma mark -
#pragma mark NSURLConnection substitution
+(WWURLConnection *)connectionWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDataDelegate, NSURLConnectionDelegate>)delegate{
    WWURLConnection *result = [WWURLConnection new];
    result.request = request;
    result.delegate = delegate;
    
    return [result autorelease];
}

#pragma mark -
#pragma mark Content redirection
+(NSMutableDictionary *)allResponses{
    static NSMutableDictionary *allResponses;
    if (allResponses == nil){
        allResponses = [[NSMutableDictionary alloc] init];
    }
    
    return allResponses;
}

+(void)setResponse:(NSData *)response forURL:(NSURL *)url{
    if (!!response) {
        WWURLMemoryResponse *responseObject = [WWURLMemoryResponse new];
        responseObject.data = response;
        
        [[self allResponses] setObject:responseObject forKey:url];
        [responseObject release];
    } else  {
        [[self allResponses] removeObjectForKey:url];
    }
}

+(NSData *)getResponseForURL:(NSURL *)url{
    id<WWURLResponse> responseObject = (id<WWURLResponse>) [[self allResponses] objectForKey:url];
    return [responseObject data];
}

+(void)setResponsesFromFileNamed:(NSString *)fileName{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    const char *routesPath = [[resourcePath stringByAppendingPathComponent:fileName] UTF8String];
    FILE *file;
    if((file = fopen(routesPath, "r+")) != NULL){
        while (!feof(file)) {
            //Read the next line ignoring comments
            NSString *line = readLineAsNSString(file);
            if ([line length] > 1 && ![[line substringToIndex:1] isEqualToString:@"#"]) {
                //Are there at least two tokens?
                NSArray *components = [line componentsSeparatedByString:@" "];
                if  ([components count] >= 2){
                    //Is the first component a valid URL?
                    NSURL *url = [NSURL URLWithString:[components objectAtIndex:0]];
                    if (!!url) {
                        //Is the second component a valid file?
                        NSString *responsePath = [resourcePath stringByAppendingPathComponent:[components objectAtIndex:1]];
                        if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
                            WWURLFileResponse *responseObject = [WWURLFileResponse new];
                            responseObject.filePath = responsePath;
                            [[self allResponses] setObject:responseObject forKey:url];
                            [responseObject release];
                        }
                    }
                    
                }
            }
        }
        fclose(file);
    }
    
}

+(NSData *)bestResponseForURL:(NSURL *)url{
    NSData *bestResponse = nil;
    NSInteger bestMatchingLevel = 0;
    
    //Iterate over the dictionary of responses to find a better matching level
    NSEnumerator *keyEnumerator = [[WWURLConnection allResponses] keyEnumerator];
    NSURL *matchURL;
    while (matchURL = [keyEnumerator nextObject]) {
        NSInteger nextMatchingLevel = [WWURLMatching matchingLevelForURL:url withURL:matchURL];
        if (nextMatchingLevel > bestMatchingLevel) {
            bestResponse = [WWURLConnection getResponseForURL:matchURL],
            bestMatchingLevel = nextMatchingLevel;
        }
    }
    
    return bestResponse;
}


+(void)clearAllResponses{
    [[self allResponses] removeAllObjects];
}

@synthesize delegate = _delegate;
@synthesize request = _request;

-(void)dealloc{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(startInBackground) object:nil];
    _delegate = nil;
    [_request release], _request = nil;
    
    [super dealloc];
}

-(void)start{
    [self performSelector:@selector(startInBackground) withObject:nil afterDelay:0.0];
}

-(void)startInBackground{
    NSData *responseData = [WWURLConnection bestResponseForURL:self.request.URL];
    if ([self.delegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        NSInteger statusCode = (!!responseData)? 200: 404;
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:statusCode HTTPVersion:nil headerFields:nil];
        [self.delegate connection:nil didReceiveResponse:response];
        [response release];
    }
    
    if ([self.delegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [self.delegate connection:nil didReceiveData:responseData];
    }
    
    if ([self.delegate respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        [self.delegate connectionDidFinishLoading:nil];
    }
}

@end
