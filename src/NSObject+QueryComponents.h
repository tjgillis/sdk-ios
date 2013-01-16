//
//  NSObject+QueryComponents.m
//  playhaven-sdk-ios
//
//

#import <Foundation/Foundation.h>

//  Adapted from http://stackoverflow.com/questions/3997976/parse-nsurl-query-property
//  Code by BadPirate(blog.logichigh.com)
//  TODO: Determine if this can be merged into PHStringUtil
@interface NSString (QueryComponents)
- (NSString *)stringByDecodingURLFormat;
- (NSString *)stringByEncodingURLFormat;
- (NSMutableDictionary *)dictionaryFromQueryComponents;
@end

@interface NSURL (QueryComponents)
- (NSMutableDictionary *)queryComponents;
@end

@interface NSDictionary (QueryComponents)
- (NSString *)stringFromQueryComponents;
@end
