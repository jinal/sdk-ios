//
//  PHAPIRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PHAPIRequest;
@protocol PHAPIRequestDelegate <NSObject>
-(void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData;
-(void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error;
@end

@interface PHAPIRequest : NSObject {
  NSURL *_URL;
  NSString *_token, *_secret;
  NSURLConnection *_connection;
  NSDictionary *_signedParameters;
  id<PHAPIRequestDelegate> _delegate;
  NSMutableData *_connectionData;
  NSString *_urlPath;
  NSDictionary *_additionalParameters;
  NSURLResponse *_response;
  int _hashCode;
}

+(NSString *) base64SignatureWithString:(NSString *)string;
+(id)requestForApp:(NSString *)token secret:(NSString *)secret;

-(id)initWithApp:(NSString *)token secret:(NSString *)secret;

@property (nonatomic, copy) NSString *urlPath;
@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) NSString *token;
@property (nonatomic, readonly) NSString *secret;
@property (nonatomic, readonly) NSDictionary *signedParameters;
@property (nonatomic, assign) id<PHAPIRequestDelegate> delegate;
@property (nonatomic, retain) NSDictionary *additionalParameters;
@property (nonatomic, assign) int hashCode;
@property (nonatomic, readonly) NSString *gid;

-(NSString *)signedParameterString;

-(void)send;

-(void)processRequestResponse:(NSDictionary *)responseData;

-(void)didSucceedWithResponse:(NSDictionary *)responseData;
-(void)didFailWithError:(NSError *)error;

@end
