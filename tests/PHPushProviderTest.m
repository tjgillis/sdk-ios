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

 PHPushProviderTest.m
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/26/13
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <SenTestingKit/SenTestingKit.h>
#import "PHPushProvider.h"
#import "PHPublisherContentRequest.h"
#import "PHError.h"

@interface PHPushProviderTest : SenTestCase <PHPushRegistrationObserver, PHPushProviderDelegate>
@property (nonatomic, retain) NSError *registrationError;
@property (nonatomic, retain) PHPublisherContentRequest *contentRequest;
@end

@implementation PHPushProviderTest

- (void)setUp
{
    self.contentRequest = nil;
}

- (void)testProviderInstance
{
    PHPushProvider *theProvider = [PHPushProvider sharedInstance];

    STAssertNotNil(theProvider, @"");
    STAssertEqualObjects(theProvider, [PHPushProvider sharedInstance], @"");
}

- (void)testRegistration
{
    PHPushProvider *theProvider = [PHPushProvider sharedInstance];

    theProvider.applicationSecret = nil;
    
    [theProvider addObserver:self];
    
    NSData *theTestToken = [@"testToken" dataUsingEncoding:NSUTF8StringEncoding];
    [theProvider registerAPNSDeviceToken:theTestToken];
    STAssertNotNil(self.registrationError, @"Registration should fail if provider's app token or"
                " secret is nil");
    STAssertEqualObjects([self.registrationError code], PHErrorIncompleteWorkflow, @"");
    
    [theProvider removeObserver:self];
    
    self.registrationError = nil;
    [theProvider registerAPNSDeviceToken:theTestToken];
    STAssertNil(self.registrationError, @"");
}

- (void)testPushNotificationHandlingCase1
{
    PHPushProvider *theProvider = [PHPushProvider sharedInstance];

    theProvider.applicationToken = @"testToken";
    theProvider.applicationSecret = @"testSecret";
    
    theProvider.delegate = self;
    
    NSString *theTestContentID = @"5767235784";
    // Check that push handling works with content ID that is a string
    [theProvider handleRemoteNotificationWithUserInfo:@{@"mi" : @"testMessageID", @"ci" :
                theTestContentID}];

    STAssertNotNil(self.contentRequest, @"Delegate method was not called during push notification "
                "handling.");
    STAssertTrue([self.contentRequest isKindOfClass:[PHPublisherContentRequest class]], @"");
    
    STAssertEqualObjects([[self.contentRequest additionalParameters] objectForKey:@"content_id"],
                theTestContentID, @"The content request sent as a result of push handling does not"
                " contain expected content unit ID");
}

- (void)testPushNotificationHandlingCase2
{
    PHPushProvider *theProvider = [PHPushProvider sharedInstance];

    theProvider.applicationToken = @"testToken";
    theProvider.applicationSecret = @"testSecret";
    
    theProvider.delegate = self;
    
    NSUInteger theTestContentID = 3238;
    // Check that push handling works with content ID that is a integer
    [theProvider handleRemoteNotificationWithUserInfo:@{@"mi" : @"testMessageID", @"ci" :
                @(theTestContentID)}];

    STAssertNotNil(self.contentRequest, @"Delegate method was not called during push notification "
                "handling.");
    STAssertTrue([self.contentRequest isKindOfClass:[PHPublisherContentRequest class]], @"");
    
    STAssertEqualObjects([[self.contentRequest additionalParameters] objectForKey:@"content_id"],
                [@(theTestContentID) stringValue], @"The content request sent as a result of push "
                "handling does not contain expected content unit ID");
}

#pragma mark - PHPushRegistrationObserver

- (void)provider:(PHPushProvider *)aProvider
            didFailToRegisterAPNSDeviceTokenWithError:(NSError *)anError
{
    self.registrationError = anError;
}

#pragma mark - PHPushProviderDelegate

- (BOOL)pushProvider:(PHPushProvider *)aProvider
            shouldSendRequest:(PHPublisherContentRequest *)aRequest
{
    self.contentRequest = aRequest;
    return NO;
}

#pragma mark - Private

- (void)dealloc
{
    [_contentRequest release];
    [_registrationError release];
    
    [super dealloc];
}

@end
