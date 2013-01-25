//
//  RewardLog.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/6/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PHReward;

@interface RewardLog : NSObject
+ (RewardLog *)sharedRewardLog;
@property(nonatomic, retain) PHReward *lastRewardUnlocked;
@end
