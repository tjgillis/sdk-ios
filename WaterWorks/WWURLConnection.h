//
//  WWURLConnection.h
//  WaterWorks
//
//  Created by Jesus Fernandez on 1/31/12.
//

#import <Foundation/Foundation.h>

//  WWURLConnection is a drop in replacement for NSURLConnection that subsitutes
//  network requests with arbitrary NSData or data from a file
@interface WWURLConnection : NSURLConnection

//  NSURLConnection replacement convenience method
+ (WWURLConnection *)connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate;

//  Sets the response data for a given URL. See WWURLMatching to see how URL
//  matching works.
+ (void)setResponse:(NSData *)response forURL:(NSURL *)url;
//  Sets responses for multiple URLs from a file. See dev.wwfixtures to see how
//  that works.
+ (void)setResponsesFromFileNamed:(NSString *)fileName;
//  Clears all configured responses
+ (void)clearAllResponses;

//  NSURLConnection replacement delegate
@property (nonatomic, assign) id delegate;

//  NSURLConnection replacement request
@property (nonatomic, retain) NSURLRequest *request;
@end
