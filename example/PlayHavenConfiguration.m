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

 PlayHavenConfiguration.m
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/15/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PlayHavenConfiguration.h"

static NSString *const kPlayhavenAppTokenKey = @"ExampleToken";
static NSString *const kPlayhavenAppSecretKey = @"ExampleSecret";

@implementation PlayHavenConfiguration

+ (PlayHavenConfiguration *)currentConfiguration
{
    static PlayHavenConfiguration *sConfigurationInsatnce = nil;
    @synchronized (self)
    {
        if (nil == sConfigurationInsatnce)
        {
            sConfigurationInsatnce = [PlayHavenConfiguration new];
        }
    }
    
    return sConfigurationInsatnce;
}

- (NSString *)applicationToken
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kPlayhavenAppTokenKey];
}

- (void)setApplicationToken:(NSString *)aToken
{
    [self storeValue:aToken forKey:kPlayhavenAppTokenKey];
}

- (NSString *)applicationSecret
{
	return [[NSUserDefaults standardUserDefaults] valueForKey:kPlayhavenAppSecretKey];
}

- (void)setApplicationSecret:(NSString *)aSecret
{
    [self storeValue:aSecret forKey:kPlayhavenAppSecretKey];
}

#pragma mark - Private

- (void)storeValue:(id)aValue forKey:(NSString *)aKey
{
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
	
    [theDefaults setValue:aValue forKey:aKey];
    [theDefaults synchronize];
}

@end
