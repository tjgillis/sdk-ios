//
//  KIFTestStep+PHAdditions.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/4/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "KIFTestStep.h"

@interface KIFTestStep (PHAdditions)
+ (id)stepToResetWithToken:(NSString *)token secret:(NSString *)secret;

// Runs arbitrary javascript in webviews. This means we can
+ (id)stepToWaitForWebViewWithAccessibilityLabelToFinishLoading:(NSString *)label;
+ (id)stepToRunJavascript:(NSString *)javascript inWebViewWithAccessibilityLabel:(NSString *)label;

@end
