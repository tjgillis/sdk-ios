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
    [result addStepsFromArray:[KIFTestStep stepsToResetAppWithToken:@"zombie1" secret:@"haven1"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"open"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"start"]];
    [result addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Request success message"]];
    return result;
}

+(id)scenarioToSendOpenRequestWithCustomDeviceId{
    KIFTestScenario *result = [KIFTestScenario scenarioWithDescription:@"Sending an open request with a custom device id..."];
    [result addStepsFromArray:[KIFTestStep stepsToResetAppWithToken:@"zombie1" secret:@"haven1"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"open"]];
    [result addStep:[KIFTestStep stepToEnterText:@"test_id" intoViewWithAccessibilityLabel:@"custom"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"start"]];
    [result addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Request success message"]];
    return result;
}

+(id)scenarioToSendContentRequest{
    KIFTestScenario *result = [KIFTestScenario scenarioWithDescription:@"Sending a content request..."];
    [result addStepsFromArray:[KIFTestStep stepsToResetAppWithToken:@"zombie1" secret:@"haven1"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"content"]];
    [result addStep:[KIFTestStep stepToEnterText:@"more_games" intoViewWithAccessibilityLabel:@"placement"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"start"]];
    [result addStep:[KIFTestStep stepToWaitForWebViewWithAccessibilityLabelToFinishLoading:@"content view"]];
    [result addStep:[KIFTestStep stepToWaitForTimeInterval:5.0 description:@"Five second timeout for context load."]];
    [result addStep:[KIFTestStep stepToRunJavascript:@"$('#more_button').trigger('click')" inWebViewWithAccessibilityLabel:@"content view"]];
    [result addStep:[KIFTestStep stepToWaitForTimeInterval:5.0 description:@"Five second timeout for context load."]];
    [result addStep:[KIFTestStep stepToRunJavascript:@"$('#dismiss_button').trigger('click')" inWebViewWithAccessibilityLabel:@"content view"]];
    [result addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Request dismiss message"]];
    
    return  result;
}

@end
