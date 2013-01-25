//
//  RewardLog.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/6/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "RewardLog.h"
#import "PHReward.h"
@implementation RewardLog

+ (RewardLog *)sharedRewardLog
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@synthesize lastRewardUnlocked = _lastRewardUnlocked;

- (void)dealloc
{
    // will never be called, but here for clarity
    [_lastRewardUnlocked release], _lastRewardUnlocked = nil;
    [super dealloc];
}
@end
