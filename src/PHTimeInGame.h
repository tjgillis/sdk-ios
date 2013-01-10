//
//  PHTimeInGame.h
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 7/5/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//  Singleton class that keeps track of elapsed session count and session time.
//  Stores data in NSUserDefaults until the next successful open request.
//  Information collected by this class is used for time-in-game segmentation
//  and targeting.
@interface PHTimeInGame : NSObject {

    CFAbsoluteTime sessionStartTime;
}

//  Singleton accessor
+(PHTimeInGame *) getInstance;

//  Start counting up time for the current session
-(void) gameSessionStarted;
//  Ends  the current session and increments counters
-(void) gameSessionStopped;
//  Resets time and session data. Typically used after data is sent to the API.
-(void) resetCounters;
//  Re-initializes session and time data. Only used for unit tests
-(void) gameSessionRestart;

//  Returns total unreported session duration, in seconds
-(CFAbsoluteTime) getSumSessionDuration;
//  Returns total unreported sessions
-(int) getCountSessions;
//  Returns current session duration, in seconds
-(CFAbsoluteTime) getCurrentSessionDuration;

@end
