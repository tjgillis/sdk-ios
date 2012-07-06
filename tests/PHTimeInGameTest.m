//
//  PHTimeInGameTest.m
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 7/5/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "PHTimeInGame.h"

@interface PHTimeInGameTest : SenTestCase
@end


@implementation PHTimeInGameTest

-(void)testTimeInGame{

    [[PHTimeInGame getInstance] gameSessionStarted];
    
    NSNumber *sessionCount = [NSNumber numberWithInt:[[PHTimeInGame getInstance] getCountSessions]];
    STAssertFalse([sessionCount intValue] == 1, @"Session count should be a value of 1");

    CFAbsoluteTime diffTime = [[PHTimeInGame getInstance] getCurrentSessionDuration];
    STAssertFalse(diffTime > 0, @"Session MUST be greater than 0");

    [[PHTimeInGame getInstance] gameSessionStopped];
    int firstCount = [[PHTimeInGame getInstance] getCountSessions];
    STAssertFalse(firstCount == 1, @"Session count should be 1");

    [[PHTimeInGame getInstance] gameSessionRestart];
    CFAbsoluteTime time = [[PHTimeInGame getInstance] getSumSessionDuration];
    STAssertFalse(time == 0, @"Session should be 0 since reset");
    int lastCount = [[PHTimeInGame getInstance] getCountSessions];
    STAssertFalse(lastCount == 0, @"Session count should be 0 since reset");
}

@end