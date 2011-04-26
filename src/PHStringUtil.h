//
//  NSStringUtil.h
//  playhaven-sdk-ios
//
//  Created by Kurtiss Hare on 2/12/10.
//  Copyright 2010 Medium Entertainment, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PHStringUtil : NSObject

// SEE: implementation for why you should not use this.
+(NSString *)stringWithQueryQuirky:(NSDictionary *)params;

+(NSString *)stringWithQuery:(NSDictionary *)params;
+(NSString *)stringByHtmlEscapingString:(NSString *)input;
+(NSString *)stringByUrlEncodingString:(NSString *)input;
+(NSString *)stringByUrlDecodingString:(NSString *)input;
+(NSString *)uuid;
+(NSDictionary *)dictionaryWithQueryString:(NSString *)input;

+(NSData *)dataDigestForString:(NSString *)input;
+(NSString *)base64EncodedStringForData:(NSData *)data;
+(NSString *)hexEncodedStringForData:(NSData *)data;
+(NSString *)hexDigestForString:(NSString *)input;
+(NSString *)b64DigestForString:(NSString *)input;

@end
