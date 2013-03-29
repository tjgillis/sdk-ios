//
//  PHConnectionManager.h
//  playhaven-sdk-ios
//
//  Created by Lilli Szafranski on 1/31/13.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PHConnectionManagerDelegate <NSObject>
@optional
- (void)connectionDidFinishLoadingWithRequest:(NSURLRequest *)request
                                     response:(NSURLResponse *)response
                                         data:(NSData *)data
                                      context:(id)context;
- (void)connectionDidFailWithError:(NSError *)error request:(NSURLRequest *)request context:(id)context;
- (void)connectionWasStoppedForRequest:(NSURLRequest *)request context:(id)context;
@end

@interface PHConnectionManager : NSObject
+ (BOOL)createConnectionFromRequest:(NSURLRequest *)request
                        forDelegate:(id <PHConnectionManagerDelegate>)delegate
                        withContext:(id)context;

+ (void)stopConnectionsForDelegate:(id<PHConnectionManagerDelegate>)delegate;
@end

