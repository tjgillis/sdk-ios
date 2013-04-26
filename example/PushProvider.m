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

 PushProvider.m
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/15/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PushProvider.h"
#import "PHPushRegistrationRequest.h"
#import "PlayHavenConfiguration.h"
#import "PHPublisherContentRequest.h"
#import "PHPushDeliveryRequest.h"

static NSString *const kPHMessageIDKey = @"mi";
static NSString *const kPHContentIDKey = @"ci";

@interface PushProvider ()
@property (nonatomic, retain) NSData *APNSDeviceToken;
@property (nonatomic, readonly) CFMutableArrayRef registrationObservers;
@end

@implementation PushProvider

+ (PushProvider *)sharedInstance
{
    static PushProvider *sPushProviderInsatnce = nil;
    @synchronized (self)
    {
        if (nil == sPushProviderInsatnce)
        {
            sPushProviderInsatnce = [PushProvider new];
        }
    }
    
    return sPushProviderInsatnce;
}

- (id)init
{
	self = [super init];
	if (nil != self)
	{
		_registrationObservers = CFArrayCreateMutable(kCFAllocatorDefault, 10, NULL);
	}
	return self;
}

- (void)dealloc
{
	CFRelease(_registrationObservers);
    [_APNSDeviceToken release];
	
	[super dealloc];
}

- (void)registerForPushNotifications
{
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
				UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert];
}

- (void)unregisterForPushNotifications
{
	[[UIApplication sharedApplication] unregisterForRemoteNotifications];
	[self registerAPNSDeviceToken:nil];
}

- (void)handleRemoteNotificationWithUserInfo:(NSDictionary *)aUserInfo
{
#warning: Custom fields of a push should be agreed/documented with a server side

    NSString *theMessageID = [aUserInfo objectForKey:kPHMessageIDKey];
    if (nil == theMessageID)
    {
        // No further actions if required field is absent.
        return;
    }
    
    PlayHavenConfiguration *theConfiguration = [PlayHavenConfiguration
                currentConfiguration];
    NSString *theContentID = [aUserInfo objectForKey:kPHContentIDKey];
    
    if (nil != theContentID)
    {
        PHPublisherContentRequest *theContentRquest = [PHPublisherContentRequest requestForApp:
                    theConfiguration.applicationToken secret:theConfiguration.applicationSecret
                    contentUnitID:theContentID];
        
        if (![self.delegate respondsToSelector:@selector(pushProvider:shouldSendRequest:)] ||
                    ([self.delegate respondsToSelector:@selector(pushProvider:shouldSendRequest:)]
                    && [self.delegate pushProvider:self shouldSendRequest:theContentRquest]))
        {
            [theContentRquest send];
        }
    }
    
    PHPushDeliveryRequest *thePushDeliveryRequest = [PHPushDeliveryRequest requestForApp:
                 theConfiguration.applicationToken secret:theConfiguration.applicationSecret
                 pushNotificationDeviceToken:self.APNSDeviceToken messageID:theMessageID
                 contentUnitID:theContentID];
    [thePushDeliveryRequest send];
}

- (void)registerAPNSDeviceToken:(NSData *)aToken
{
    self.APNSDeviceToken = aToken;
    
    PlayHavenConfiguration *theConfiguration = [PlayHavenConfiguration
				currentConfiguration];
	
	PHPushRegistrationRequest *theRequest = [PHPushRegistrationRequest requestForApp:
				theConfiguration.applicationToken secret:
				theConfiguration.applicationSecret pushNotificationDeviceToken:aToken];
	
	theRequest.delegate = self;
	[theRequest send];
}

- (void)addObserver:(id<PushRegistrationObserver>)anObserver
{
	if (!CFArrayContainsValue(self.registrationObservers, CFRangeMake(0,
				CFArrayGetCount(self.registrationObservers)), anObserver))
	{
		CFArrayAppendValue(self.registrationObservers, anObserver);
	}
}

- (void)removeObserver:(id<PushRegistrationObserver>)anObserver
{
	if (CFArrayContainsValue(self.registrationObservers, CFRangeMake(0,
				CFArrayGetCount(self.registrationObservers)), anObserver))
	{
		CFArrayRemoveValueAtIndex(self.registrationObservers, CFArrayGetFirstIndexOfValue(
					self.registrationObservers, CFRangeMake(0, CFArrayGetCount(
					self.registrationObservers)), anObserver));
	}
}

#pragma mark - PHAPIRequestDelegate

- (void)request:(PHAPIRequest *)aRequest
			didSucceedWithResponse:(NSDictionary *)aResponseData
{
	for (unsigned theIndex = 0; theIndex < CFArrayGetCount(self.registrationObservers);
				++theIndex)
	{
		id<PushRegistrationObserver> theObserver = CFArrayGetValueAtIndex(
					self.registrationObservers, theIndex);
		if ([theObserver respondsToSelector:@selector(provider:didSucceedWithResponse:)])
		{
			[theObserver provider:self didSucceedWithResponse:aResponseData];
		}
	}
}

- (void)request:(PHAPIRequest *)aRequest didFailWithError:(NSError *)anError
{
	for (unsigned theIndex = 0; theIndex < CFArrayGetCount(self.registrationObservers);
				++theIndex)
	{
		id<PushRegistrationObserver> theObserver = CFArrayGetValueAtIndex(
					self.registrationObservers, theIndex);
		if ([theObserver respondsToSelector:@selector(provider:didFailWithError:)])
		{
			[theObserver provider:self didFailWithError:anError];
		}
	}
}

@end
