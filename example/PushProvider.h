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

 PushProvider.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/15/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "PlayHavenSDK.h"

@protocol PushRegistrationObserver;
@protocol PushProviderDelegate;

/**
 * @brief Provides ability to register/unregister for push notification.
 **/
@interface PushProvider : NSObject <PHAPIRequestDelegate>
+ (PushProvider *)sharedInstance;

@property (nonatomic, assign) id<PushProviderDelegate> delegate;

/**
 * Registers device token with PlayHaven's push server. This call completes the
 * push notification registration procedure and after that the application will be able to
 * receive remote notification.
 **/
- (void)registerAPNSDeviceToken:(NSData *)aToken;

/**
 * Registers for push notifications by passing APNS which kind of notifications the
 * application accepts.
 **/
- (void)registerForPushNotifications;

/**
 * Unregisters for push notifications received from Apple Push Service and also tells
 * PlayHaven's server to stop sending push notifications for this application instance.
 **/
- (void)unregisterForPushNotifications;

/**
 * Handles incoming push notifications which system provides in form of dictionary containing
 * information about notification, for more details on the dictionary content see
 * application:didReceiveRemoteNotification: of UIApplicationDelegate.
 **/
- (void)handleRemoteNotificationWithUserInfo:(NSDictionary *)aUserInfo;

/**
 * Adds new observer which will be notified about the results of registration/
 * unregistration events.
 *
 * @param anObserver
 *	Observers are not retained and caller is responsible for removing observer at before
 *	it is released.
 **/
- (void)addObserver:(id<PushRegistrationObserver>)anObserver;
- (void)removeObserver:(id<PushRegistrationObserver>)anObserver;
@end

@protocol PushRegistrationObserver <NSObject>
@optional
- (void)provider:(PushProvider *)aProvider
			didSucceedWithResponse:(NSDictionary *)aResponse;
- (void)provider:(PushProvider *)aProvider
			didFailWithError:(NSError *)anError;
@end

@protocol PushProviderDelegate <NSObject>
@optional
- (BOOL)pushProvider:(PushProvider *)aProvider
            shouldSendRequest:(PHPublisherContentRequest *)aRequest;
@end
