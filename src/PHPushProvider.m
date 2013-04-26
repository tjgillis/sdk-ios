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

 PHPushProvider.m
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/15/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHPushProvider.h"
#import "PHPushRegistrationRequest.h"
#import "PHPublisherContentRequest.h"
#import "PHPushDeliveryRequest.h"

static NSString *const kPHMessageIDKey = @"mi";
static NSString *const kPHContentIDKey = @"ci";

@interface PHPushProvider ()
@property (nonatomic, retain) NSData *APNSDeviceToken;
@property (nonatomic, readonly) CFMutableArrayRef registrationObservers;
@end

@implementation PHPushProvider

+ (PHPushProvider *)sharedInstance
{
    static PHPushProvider *sPHPushProviderInsatnce = nil;
    @synchronized (self)
    {
        if (nil == sPHPushProviderInsatnce)
        {
            sPHPushProviderInsatnce = [PHPushProvider new];
        }
    }
    
    return sPHPushProviderInsatnce;
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
    [_applicationToken release];
    [_applicationSecret release];
	
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
    
    NSString *theContentID = [aUserInfo objectForKey:kPHContentIDKey];
    
    if (nil != theContentID)
    {
        PHPublisherContentRequest *theContentRquest = [PHPublisherContentRequest requestForApp:
                    self.applicationToken secret:self.applicationSecret contentUnitID:theContentID];
        
        if (![self.delegate respondsToSelector:@selector(PHPushProvider:shouldSendRequest:)] ||
                    ([self.delegate respondsToSelector:@selector(PHPushProvider:shouldSendRequest:)]
                    && [self.delegate PHPushProvider:self shouldSendRequest:theContentRquest]))
        {
            [theContentRquest send];
        }
    }
    
    PHPushDeliveryRequest *thePushDeliveryRequest = [PHPushDeliveryRequest requestForApp:
                 self.applicationToken secret:self.applicationSecret pushNotificationDeviceToken:
                 self.APNSDeviceToken messageID:theMessageID contentUnitID:theContentID];
    [thePushDeliveryRequest send];
}

- (void)registerAPNSDeviceToken:(NSData *)aToken
{
    self.APNSDeviceToken = aToken;
    
	PHPushRegistrationRequest *theRequest = [PHPushRegistrationRequest requestForApp:
				self.applicationToken secret: self.applicationSecret pushNotificationDeviceToken:
                aToken];
	
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
