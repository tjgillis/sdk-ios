//
//  PHResourceCacher.h
//  playhaven-sdk-ios
//
//  Created by Lilli Szafranski on 1/31/13.
//  Copyright 2013 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: Optimize the imports
#import "PHConnectionManager.h"
#import "PlayHavenSDK.h"

@interface PHResourceCacher : NSObject <PHConnectionManagerDelegate, UIWebViewDelegate, PHPublisherContentRequestDelegate>
@property (nonatomic, retain) UIWebView *webView;

+ (void)cacheObject:(NSString *)object;
+ (BOOL)isRequestPending:(NSString *)requestUrlString;

+ (void)pause;
+ (void)resume;
@end
