//
//  PHTestController.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/1/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "PHTestController.h"
#import "KIFTestScenario.h"
#import "KIFTestScenario+PHAdditions.h"

@implementation PHTestController

- (void)initializeScenarios
{
    [self addScenario:[KIFTestScenario scenarioToSendOpenRequest]];
    [self addScenario:[KIFTestScenario scenarioToSendOpenRequestWithCustomDeviceId]];
//    [self addScenario:[KIFTestScenario scenarioToSendContentRequest]];
    [self addScenario:[KIFTestScenario scenarioToSendContentRequestTestingReward]];
    [self addScenario:[KIFTestScenario scenarioToSendContentRequestTestingAnnouncementLaunch]];
    [self addScenario:[KIFTestScenario scenarioToLoadiTunesAndVerifyReferral]];
}
@end
