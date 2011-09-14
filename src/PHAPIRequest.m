//
//  PHAPIRequest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHAPIRequest.h"

#import "NSObject+QueryComponents.h"
#import "PHStringUtil.h"
#import "SBJsonParser.h"
#import "UIDevice+HardwareString.h"
#import "PHConstants.h"

@implementation PHAPIRequest

+(NSString *) base64SignatureWithString:(NSString *)string{
  return [PHStringUtil b64DigestForString:string];
}


+(id) requestForApp:(NSString *)token secret:(NSString *)secret{
  return [[[[self class] alloc] initWithApp:token secret:secret] autorelease];
}

-(id) initWithApp:(NSString *)token secret:(NSString *)secret{
  if ((self = [super init])) {
    _token = [token copy];
    _secret = [secret copy];
  }
  
  return self;
}

@synthesize token = _token, secret = _secret;
@synthesize delegate = _delegate;
@synthesize urlPath = _urlPath;
@synthesize additionalParameters = _additionalParameters;
@synthesize hashCode = _hashCode;

-(NSURL *) URL{
  if (_URL == nil) {
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",
                           [self urlPath],
                           [self signedParameterString]];
    _URL = [[NSURL alloc] initWithString:urlString]; 
  }
  
  return _URL;
}

-(NSDictionary *) signedParameters{
  if (_signedParameters == nil) {
    NSString
    *device = [[UIDevice currentDevice] uniqueIdentifier],
    *nonce = [PHStringUtil uuid],
    *signatureHash = [NSString stringWithFormat:@"%@:%@:%@:%@", self.token, device, nonce, self.secret],
    *signature = [PHAPIRequest base64SignatureWithString:signatureHash],
    *appId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"],
    *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
    *hardware = [[UIDevice currentDevice] hardware],
    *os = [NSString stringWithFormat:@"%@ %@",
           [[UIDevice currentDevice] systemName],
           [[UIDevice currentDevice] systemVersion]];
    if(!appVersion) appVersion = @"NA";
    
    NSNumber *idiom = [NSNumber numberWithInt:(int)UI_USER_INTERFACE_IDIOM()];
    
    
    NSMutableDictionary *additionalParams = (!!self.additionalParameters)? [self.additionalParameters mutableCopy]: [[NSMutableDictionary alloc] init];  
    NSDictionary *signatureParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                     device, @"device",
                                     self.token, @"token",
                                     signature, @"signature",
                                     nonce, @"nonce",
                                     appId, @"app",
                                     hardware,@"hardware",
                                     os,@"os",
                                     idiom,@"idiom",
                                     appVersion, @"app_version",
                                     nil];
    
    [additionalParams addEntriesFromDictionary:signatureParams];
    _signedParameters = additionalParams;
  }

  return _signedParameters;       
}

-(NSString *) signedParameterString{
  return [[self signedParameters] stringFromQueryComponents];
}

-(void) dealloc{
  [_connection cancel];
  
  [_token release], _token = nil;
  [_secret release], _secret = nil;
  [_URL release], _URL = nil;
  [_connection release], _connection = nil;
  [_signedParameters release], _signedParameters = nil;
  [_connectionData release], _connectionData = nil;
  [_urlPath release], _urlPath = nil;
  [_additionalParameters release], _additionalParameters = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark PHPublisherOpenRequest

-(void) send{
  if (_connection == nil) {
    NSLog(@"[PlayHaven] Sending request: %@", [self.URL absoluteString]);
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_connection start];
    
    //REQUEST_RETAIN see REQUEST_RELEASE
    [self retain];
  }
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
  /*
   Nearly all connections made by the SDK will return a NSHTTPURLResponse, but we would like also make requests to file:// URLs as well.
  */
  if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"[PlayHaven] Request recieved HTTP response: %d", [httpResponse statusCode]);
    
    if ([httpResponse statusCode] == 200) {
      [_connectionData release], _connectionData = [[NSMutableData alloc] init];
      [_response release], _response = [response retain];
    } else {
      [self didFailWithError:PHCreateError(PHAPIResponseErrorType)];
      [connection cancel];
    }
  } else {
    [_connectionData release], _connectionData = [[NSMutableData alloc] init];
    [_response release], _response = nil;
  }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
  [_connectionData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
  NSLog(@"[PlayHaven] Request finished!");
  if (!!self.delegate) {
    NSString *responseString = [[NSString alloc] initWithData:_connectionData encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary* resultDictionary = [parser objectWithString:responseString];
    [self processRequestResponse:resultDictionary];
    
    [parser release];
    [responseString release];
  }
  
  //REQUEST_RELEASE see REQUEST_RETAIN
  [self release];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
  NSLog(@"[PlayHaven] Request failed with error: %@", [error localizedDescription]);
  //REQUEST_RELEASE see REQUEST_RETAIN
  [self didFailWithError:error];
  [self release];
}

#pragma mark -
-(void)processRequestResponse:(NSDictionary *)responseData{
  id responseValue = [responseData valueForKey:@"response"];
  if (!!responseValue && ![responseValue isEqual:[NSNull null]]) {
    [self didSucceedWithResponse:responseValue];
  } else {    
    [self didFailWithError:PHCreateError(PHRequestResponseErrorType)];
  }
}

-(void)didSucceedWithResponse:(NSDictionary *)responseData{
  if ([self.delegate respondsToSelector:@selector(request:didSucceedWithResponse:)]) {
    [self.delegate performSelector:@selector(request:didSucceedWithResponse:) withObject:self withObject:responseData];
  }
}

-(void)didFailWithError:(NSError *)error{
  if ([self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
    [self.delegate performSelector:@selector(request:didFailWithError:) withObject:self withObject:error];
  }
}

@end
