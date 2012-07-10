//
//  KIFTestScenario+PHAdditions.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/1/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "KIFTestScenario+PHAdditions.h"

#import "KIFTestStep.h"
#import "KIFTestStep+PHAdditions.h"


@implementation KIFTestScenario(PHAdditions)
+(id)scenarioToSendOpenRequest{
    KIFTestScenario *result = [KIFTestScenario scenarioWithDescription:@"Sending an open request..."];
    [result addStepsFromArray:[KIFTestStep stepsToResetApp]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"open"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"start"]];
    [result addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Request success message"]];
    return result;
}

+(id)scenarioToSendOpenRequestWithCustomDeviceId{
    KIFTestScenario *result = [KIFTestScenario scenarioWithDescription:@"Sending an open request with a custom device id..."];
    [result addStepsFromArray:[KIFTestStep stepsToResetApp]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"open"]];
    [result addStep:[KIFTestStep stepToEnterText:@"test_id" intoViewWithAccessibilityLabel:@"custom"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"start"]];
    [result addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Request success message"]];
    return result;
}

+(id)scenarioToSendContentRequest{
    KIFTestScenario *result = [KIFTestScenario scenarioWithDescription:@"Sending a content request..."];
    [result addStepsFromArray:[KIFTestStep stepsToResetApp]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"content"]];
    [result addStep:[KIFTestStep stepToEnterText:@"more_games" intoViewWithAccessibilityLabel:@"placement"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"start"]];
    
    //featured game content unit
    [result addStep:[KIFTestStep stepToWaitForDispatch:@"ph://loadContext" andCallback:YES]];
    [result addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"HACKY: Waiting for the webview to finish rendering before attempting to tap button."]];
    [result addStep:[KIFTestStep stepToTapElementWithSelector:@"#more_button" inWebViewWithAccessibilityLabel:@"content view"]];
    [result addStep:[KIFTestStep stepToWaitForDispatch:@"ph://subcontent"]];
    [result addStep:[KIFTestStep stepToWaitForDispatch:@"ph://dismiss"]];
    
    //more games content unit
    [result addStep:[KIFTestStep stepToWaitForDispatch:@"ph://loadContext" andCallback:YES]];
    [result addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"HACKY: Waiting for the webview to finish rendering before attempting to tap button."]];
    [result addStep:[KIFTestStep stepToTapElementWithSelector:@"#dismiss_button" inWebViewWithAccessibilityLabel:@"content view"]];
    [result addStep:[KIFTestStep stepToWaitForDispatch:@"ph://dismiss"]];
    [result addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"content view"]];
    
    return  result;
}

+(id)scenarioToSendContentRequestTestingReward{
    KIFTestScenario *result = [KIFTestScenario scenarioWithDescription:@"Sending a content request and verifying it returns a reward"];
    [result addStepsFromArray:[KIFTestStep stepsToResetApp]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"content"]];
    [result addStep:[KIFTestStep stepToEnterText:@"reward" intoViewWithAccessibilityLabel:@"placement"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"start"]];

    
    //reward content unit
    [result addStep:[KIFTestStep stepToWaitForDispatch:@"ph://loadContext" andCallback:YES]];
    [result addStep:[KIFTestStep stepToVerifyRewardUnlocked:@"delicious_cake" quantity:1]];
    [result addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"HACKY: Waiting for the webview to finish rendering before attempting to tap button."]];
    [result addStep:[KIFTestStep stepToTapElementWithSelector:@"#button" inWebViewWithAccessibilityLabel:@"content view"]];
    [result addStep:[KIFTestStep stepToWaitForDispatch:@"ph://dismiss"]];
    [result addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"content view"]];
    return result;
}

+(id)scenarioToSendContentRequestTestingAnnouncementLaunch{
    KIFTestScenario *result =[KIFTestScenario scenarioWithDescription:@"Sending a content request and testing announcement launch"];
    [result addStepsFromArray:[KIFTestStep stepsToResetApp]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"content"]];
    [result addStep:[KIFTestStep stepToEnterText:@"announcement_launch" intoViewWithAccessibilityLabel:@"placement"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"start"]];
    
    //announcement content unit
    [result addStep:[KIFTestStep stepToWaitForDispatch:@"ph://loadContext" andCallback:YES]];
    [result addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"HACKY: Waiting for the webview to finish rendering before attempting to tap button."]];
    [result addStep:[KIFTestStep stepToTapElementWithSelector:@"#button" inWebViewWithAccessibilityLabel:@"content view"]];
    [result addStep:[KIFTestStep stepToVerifyLaunchURL:@"http://www.playhaven.com/"]];
    [result addStep:[KIFTestStep stepToWaitForDispatch:@"ph://dismiss"]];
    [result addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"content view"]];
    return result;
}
@end
