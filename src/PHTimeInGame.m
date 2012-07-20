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
            shared->sessionStartTime = 0;

            // UIApplicationDidBecomeActiveNotification - use instead of UIApplicationWillEnterForegroundNotification
            // UIApplicationWillResignActiveNotification - use instead of UIApplicationDidEnterBackgroundNotification (NO)
            [[NSNotificationCenter defaultCenter] addObserver:[PHTimeInGame class] selector:@selector(gameSessionStopped) name:UIApplicationWillTerminateNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:[PHTimeInGame class] selector:@selector(gameSessionStopped) name:UIApplicationDidEnterBackgroundNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:[PHTimeInGame class] selector:@selector(gameSessionStarted) name:UIApplicationWillEnterForegroundNotification object:nil];
        }
    });
	
	return shared;
}

-(void) dealloc {
	// should never be called since we're using a singleton pattern
    // calling [super dealloc] here to suppress a compiler warning
    [super dealloc];
}

-(void) gameSessionStarted {

    sessionStartTime = CFAbsoluteTimeGetCurrent();

    int currentSessionCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHSessionCount"] intValue];
    currentSessionCount++;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:currentSessionCount] forKey:@"PHSessionCount"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PHSessionDuration"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) gameSessionStopped {
    
    if (sessionStartTime == 0)
        return;
    
    // Add the time of the session to the duration
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime differenceTime = currentTime - sessionStartTime;
    CFAbsoluteTime totalDurationTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHSessionDuration"] doubleValue];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:differenceTime + totalDurationTime] forKey:@"PHSessionDuration"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    sessionStartTime = currentTime;
}

/*
 The following data is sent in the Open request to the PH server:
 ssum = It is the sum of session duration (since last successful "open") - getSumSessionDuration
 scount = A count of sessions (since last successful "open"). Used if player offline and still playing - getCountSessions
 
 The following data is sent in every Content request to the PH server:
 stime = That is the duration of the current session thus far - getCurrentSessionDuration
 */

-(CFAbsoluteTime) getSumSessionDuration {
    
    if (sessionStartTime == 0)
        return 0;
    
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime differenceTime = currentTime - sessionStartTime;
    CFAbsoluteTime totalDurationTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHSessionDuration"] doubleValue];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:differenceTime + totalDurationTime] forKey:@"PHSessionDuration"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    sessionStartTime = currentTime;
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHSessionDuration"] doubleValue];
}

-(int) getCountSessions {
    
    if (sessionStartTime == 0)
        return 0;
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHSessionCount"] intValue];
}

-(void) gameSessionRestart {
    
    if (sessionStartTime == 0)
        return;
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PHSessionCurrent"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PHSessionDuration"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PHSessionCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(CFAbsoluteTime) getCurrentSessionDuration {

    if (sessionStartTime == 0)
        return 0;
    
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime differenceTime = currentTime - sessionStartTime;
    CFAbsoluteTime totalDurationTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHSessionDuration"] doubleValue];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:differenceTime + totalDurationTime] forKey:@"PHSessionDuration"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    sessionStartTime = currentTime;
    return differenceTime + totalDurationTime;
}

@end
