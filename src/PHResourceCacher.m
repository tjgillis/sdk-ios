/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright 2013 Medium Entertainment, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 PHResourceCacher.h
 playhaven-sdk-ios

 Created by Lilli Szafranski on 1/31/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHConnectionManager.h"
#import "PHResourceCacher.h"
#import "PHConstants.h"

@interface NSMutableArray (PushPopObject)
- (id)popObjectAtIndex:(NSUInteger)index;
- (void)pushObjectToFront:(id)object;
- (void)pushObjectToBack:(id)object;
@end

@implementation NSMutableArray (PopObject)
- (id)popObjectAtIndex:(NSUInteger)index
{
    id object = [[[self objectAtIndex:index] retain] autorelease];

    [self removeObjectAtIndex:index];

    return object;
}

- (void)pushObjectToFront:(id)object
{
    [self insertObject:object atIndex:0];
}

- (void)pushObjectToBack:(id)object
{
    [self insertObject:object atIndex:[self count]];
}
@end

@interface PHResourceCacher ()
@property (retain) NSMutableArray *cacherQueue;
@property (retain) NSString       *currentlyCachingUrl;
@end

@implementation PHResourceCacher
@synthesize webView = _webView;
@synthesize cacherQueue         = _cacherQueue;
@synthesize currentlyCachingUrl = _currentlyCachingUrl;

static PHResourceCacher *singleton = nil;

- (id)init
{
    if ((self = [super init]))
    {
        _cacherQueue = [[NSMutableArray alloc] initWithCapacity:6];
    }

    return self;
}

+ (id)sharedInstance
{
    if (singleton == nil) {
        singleton = [((PHResourceCacher *)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release { }

- (id)autorelease
{
    return self;
}

+ (BOOL)isRequestPending:(NSString *)requestUrlString
{
    return ([requestUrlString isEqualToString:[[PHResourceCacher sharedInstance] currentlyCachingUrl]]);
}

- (NSURLRequest *)requestForObject:(NSString *)object
{
    NSURL *url = [NSURL URLWithString:object];

    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:PH_REQUEST_TIMEOUT + 10];

    return request;
}

- (void)startDownloadingObject:(id)object
{
    PH_DEBUG(@"Caching object: %@", object);

    self.currentlyCachingUrl = object;

    [PHConnectionManager createConnectionFromRequest:[self requestForObject:object]
                                         forDelegate:self
                                         withContext:nil];
}

- (void)pause
{
    [self.cacherQueue pushObjectToFront:self.currentlyCachingUrl];

    self.currentlyCachingUrl = nil;
}

+ (void)pause
{
    [[PHResourceCacher sharedInstance] pause];
}

- (void)resume
{
    if ([self.cacherQueue count] && !self.currentlyCachingUrl)
        [self startDownloadingObject:[self.cacherQueue popObjectAtIndex:0]];
}

+ (void)resume
{
    [[PHResourceCacher sharedInstance] resume];
}

+ (void)cacheObject:(NSString *)object
{
    PHResourceCacher *cacher = [PHResourceCacher sharedInstance];

    [cacher.cacherQueue pushObjectToBack:object];
    [cacher resume];
}

- (void)connectionDidFailWithError:(NSError *)error request:(NSURLRequest *)request context:(id)context
{
    PH_DEBUG(@"Failed caching object: %@, with error: %@", request.URL.absoluteString, [error localizedDescription]);

    self.currentlyCachingUrl = nil;

    [[NSNotificationCenter defaultCenter] postNotificationName:PH_PRECACHER_CALLBACK_NOTIFICATION
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                     request, @"request",
                                                                                     error,   @"error", nil]];

    if ([self.cacherQueue count])
        [self startDownloadingObject:[self.cacherQueue popObjectAtIndex:0]];
}

- (void)connectionDidFinishLoadingWithRequest:(NSURLRequest *)request response:(NSURLResponse *)response data:(NSData *)data context:(id)context
{
    PH_DEBUG(@"Finished caching object: %@", request.URL.absoluteString);

    self.currentlyCachingUrl = nil;

    [[NSNotificationCenter defaultCenter] postNotificationName:PH_PRECACHER_CALLBACK_NOTIFICATION
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                     request,  @"request",
                                                                                     response, @"response",
                                                                                     data,     @"data", nil]];


    if ([self.cacherQueue count])
        [self startDownloadingObject:[self.cacherQueue popObjectAtIndex:0]];
}

- (void)connectionWasStoppedForRequest:(NSURLRequest *)request context:(id)context
{
    self.currentlyCachingUrl = nil;

    [[NSNotificationCenter defaultCenter] postNotificationName:PH_PRECACHER_CALLBACK_NOTIFICATION
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                     request,  @"request", nil]];
}

- (void)dealloc
{
    [_webView release];
    [_cacherQueue release];
    [_currentlyCachingUrl release];

    [super dealloc];
}
@end
