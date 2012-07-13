//
//  KIFTestScenario+PHAdditions.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/1/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIFTestScenario.h"

@interface KIFTestScenario(PHAdditions)
+(id)scenarioToSendOpenRequest;
+(id)scenarioToSendOpenRequestWithCustomDeviceId;
+(id)scenarioToSendContentRequest;
+(id)scenarioToSendContentRequestTestingReward;
+(id)scenarioToSendContentRequestTestingAnnouncementLaunch;
+(id)scenarioToLoadiTunesAndVerifyReferral;
@end
