//
//  KIFTestStep+PHAdditions.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/4/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "KIFTestStep.h"

@interface KIFTestStep (PHAdditions)
+ (NSArray *)stepsToResetApp;

// Runs arbitrary javascript in webviews. This means we can
+ (id)stepToWaitForWebViewWithAccessibilityLabelToFinishLoading:(NSString *)label;
+ (id)stepToRunJavascript:(NSString *)javascript inWebViewWithAccessibilityLabel:(NSString *)label;
+ (id)stepToRunJavascript:(NSString *)javascript inWebViewWithAccessibilityLabel:(NSString *)label expectedResult:(NSString *)expectedResult;

+ (id)stepToTapElementWithSelector:(NSString *)selector inWebViewWithAccessibilityLabel:(NSString *)label;

+ (id)stepToClearTextFromViewWithAccessibilityLabel:(NSString *)label;

// SDK specific steps
+ (id)stepToVerifyRewardUnlocked:(NSString *)reward quantity:(NSInteger)quantity;
+ (id)stepToVerifyLaunchURL:(NSString *)urlPath;
+ (id)stepToVerifyLaunchURLContainsHost:(NSString *)host;
+ (id)stepToVerifyLaunchURLContainsParameter:(NSString *)parameter;
+ (id)stepToWaitForDispatch:(NSString *)dispatch;
+ (id)stepToWaitForDispatch:(NSString *)dispatch andCallback:(BOOL)waitForCallback;
@end
