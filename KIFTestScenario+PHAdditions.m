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

+(id)scenarioToTestFieldManipulation{
    KIFTestScenario *result = [KIFTestScenario scenarioWithDescription:@"Testing fields..."];
    [result addStep:[KIFTestStep stepToResetWithToken:@"" secret:@""]];
    [result addStep:[KIFTestStep stepToEnterText:@"token" intoViewWithAccessibilityLabel:@"token"]];
    [result addStep:[KIFTestStep stepToEnterText:@"secret" intoViewWithAccessibilityLabel:@"secret"]];
    
    return result;
}

+(id)scenarioToSendOpenRequest{
    KIFTestScenario *result = [KIFTestScenario scenarioWithDescription:@"Sending an open request..."];
    [result addStep:[KIFTestStep stepToResetWithToken:@"zombie1" secret:@"haven1"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"open"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"start"]];
    [result addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Request success message"]];
    return result;
}

+(id)scenarioToSendOpenRequestWithCustomDeviceId{
    KIFTestScenario *result = [KIFTestScenario scenarioWithDescription:@"Sending an open request with a custom device id..."];
    [result addStep:[KIFTestStep stepToResetWithToken:@"zombie1" secret:@"haven1"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"open"]];
    [result addStep:[KIFTestStep stepToEnterText:@"test_id" intoViewWithAccessibilityLabel:@"custom"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"start"]];
    [result addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Request success message"]];
    return result;
}

+(id)scenarioToSendContentRequest{
    KIFTestScenario *result = [KIFTestScenario scenarioWithDescription:@"Sending a content request..."];
    [result addStep:[KIFTestStep stepToResetWithToken:@"zombie1" secret:@"haven1"]];
    [result addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"content"]];
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
