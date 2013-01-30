//
//  PHReward+Automation.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/7/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "PHReward+Automation.h"

static PHReward *LastReward;

@implementation PHReward (Automation)

+ (PHReward *)lastReward
{
    @synchronized ([PHReward class]) {
        return LastReward;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        @synchronized ([PHReward class]) {
            [LastReward release], LastReward = [self retain];
        }
    }

    return  self;
}
@end
