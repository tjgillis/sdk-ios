//
//  NSStringUtil.h
//  playhaven-sdk-ios
//
//  Created by Kurtiss Hare on 2/12/10.
//  Copyright 2010 Medium Entertainment, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

//  String utility class
@interface PHStringUtil : NSObject

// SEE: implementation for why you should not use this.
+ (NSString *)stringWithQueryQuirky:(NSDictionary *)params;

// generates a unique uuid
+ (NSString *)uuid;

// generates a URL query string using a dictionary of parameters
+ (NSString *)stringWithQuery:(NSDictionary *)params;
+ (NSString *)stringByHtmlEscapingString:(NSString *)input;
+ (NSString *)stringByUrlEncodingString:(NSString *)input;
+ (NSString *)stringByUrlDecodingString:(NSString *)input;

// generates a dictionary from a URL query parameter string
+ (NSDictionary *)dictionaryWithQueryString:(NSString *)input;

// string digest and encoding functions, mostly for signatures
+ (NSData *)dataDigestForString:(NSString *)input;
+ (NSString *)base64EncodedStringForData:(NSData *)data;
+ (NSString *)hexEncodedStringForData:(NSData *)data;
+ (NSString *)hexDigestForString:(NSString *)input;
+ (NSString *)b64DigestForString:(NSString *)input;
@end
