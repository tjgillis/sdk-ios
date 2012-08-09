//
//  PHTimeInGame.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 7/5/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import "PHTimeInGame.h"

@implementation PHTimeInGame

static PHTimeInGame * shared = nil;

+(PHTimeInGame *) getInstance {
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shared == nil) {
            shared = [PHTimeInGame new];
        }
    });
	
	return shared;
}

-(id)init{
    self = [super init];
    if (self) {
        sessionStartTime = 0;
        lastSumSessionDuration = 0;
    }
    
    return self;
}

-(void) gameSessionStarted {

    sessionStartTime = CFAbsoluteTimeGetCurrent();

    [[NSNotificationCenter defaultCenter] addObserver:[PHTimeInGame getInstance] selector:@selector(gameSessionStopped) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[PHTimeInGame getInstance] selector:@selector(gameSessionStopped) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    int currentSessionCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"PHSessionCount"] + 1;
    [[NSUserDefaults standardUserDefaults] setInteger:currentSessionCount forKey:@"PHSessionCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) gameSessionStopped {

    if (sessionStartTime == 0)
        return;
    
    // Record elapsed time for this session
    [[NSUserDefaults standardUserDefaults] setDouble:[self getSumSessionDuration] forKey:@"PHSessionDuration"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    sessionStartTime = 0;
}

/*
 The following data is sent in the Open request to the PH server:
 ssum = It is the sum of session duration (since last successful "open") - getSumSessionDuration
 scount = A count of sessions (since last successful "open"). Used if player offline and still playing - getCountSessions
 
 The following data is sent in every Content request to the PH server:
 stime = That is the duration of the current session thus far - getCurrentSessionDuration
 */

-(CFAbsoluteTime) getSumSessionDuration {
    
    CFAbsoluteTime totalDurationTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"PHSessionDuration"] + [self getCurrentSessionDuration];

    //record last reported sumSessionDuration;
    lastSumSessionDuration = totalDurationTime;
    
    return totalDurationTime;
}

-(int) getCountSessions {    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"PHSessionCount"];
}

/*
This method should only be invoked for testing purposes as it will destroy session data.
*/
-(void) gameSessionRestart {
    sessionStartTime = 0;
    lastSumSessionDuration = 0;

    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PHSessionDuration"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PHSessionCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(CFAbsoluteTime) getCurrentSessionDuration {

    if (sessionStartTime == 0)
        return 0;
    
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime differenceTime = currentTime - sessionStartTime;
    return differenceTime;
}

/*

After time in game data has been reported to the API, we will purge that amount of time from the stored session duration.
 
*/
-(void)resetLastSumSessionDuration{
    CFAbsoluteTime newTotalDuration = [self getSumSessionDuration] - lastSumSessionDuration;
    [[NSUserDefaults standardUserDefaults] setDouble:newTotalDuration forKey:@"PHSessionDuration"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    lastSumSessionDuration = 0;
}

@end
