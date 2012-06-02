//
//  KIFTestScenario+PHAdditions.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/1/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "KIFTestScenario+PHAdditions.h"
#import "KIFTestStep.h"

@implementation KIFTestScenario(PHAdditions)
+(id)scenarioToFillInTokenAndSecret{
    KIFTestScenario *result = [KIFTestScenario scenarioWithDescription:@"Filling in token and secret."];
    [result addStep:[KIFTestStep stepToEnterText:@"zombie2" intoViewWithAccessibilityLabel:@"token"]];
    [result addStep:[KIFTestStep stepToEnterText:@"haven1" intoViewWithAccessibilityLabel:@"secret"]];
    return result;
}
@end
