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

 PHPushDeliveryRequest.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/25/13
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHPushRegistrationRequest.h"

@interface PHPushDeliveryRequest : PHPushRegistrationRequest

+ (id)requestForApp:(NSString *)aToken secret:(NSString *)aSecret
			pushNotificationDeviceToken:(NSData *)aDeviceToken messageID:(NSString *)aMessageID
            contentUnitID:(NSString *)aContentID;

- (id)initWithApp:(NSString *)aToken secret:(NSString *)aSecret
			pushNotificationDeviceToken:(NSData *)aDeviceToken messageID:(NSString *)aMessageID
            contentUnitID:(NSString *)aContentID;

@end
