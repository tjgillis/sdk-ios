//
//  KIFTestStep+PHAdditions.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/4/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "KIFTestStep+PHAdditions.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"

#import "PHReward.h"
#import "PHReward+Automation.h"
#import "PHURLLoader.h"
#import "PHURLLoader+Automation.h"
#import "PHContentView.h"
#import "PHContentView+Automation.h"

#import "SBJsonParser.h"

@interface KIFTestStep()
+ (UIAccessibilityElement *)_accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value tappable:(BOOL)mustBeTappable traits:(UIAccessibilityTraits)traits error:(out NSError **)error;
+ (BOOL)_enterCharacter:(NSString *)characterString;
@end

@implementation KIFTestStep (PHAdditions)
+(NSArray *)stepsToResetApp{
    return [NSArray arrayWithObjects:
            [KIFTestStep stepWithDescription:@"Reset the app"
                              executionBlock:^(KIFTestStep *step, NSError **error) {
                                  //reset to home screen and set token and secret. This will automatically cancel any open requests if they did not clean up properly
                                  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  [delegate.navigationController popToRootViewControllerAnimated:YES];
                                  
                                  //reset dispatch log to prevent dispatches from matching dispatches from a previous test
                                  [[PHContentView _dispatchLog] removeAllObjects];
                                  
                                  return KIFTestStepResultSuccess;
                              }],
            nil];
}

+(id)stepToWaitForWebViewWithAccessibilityLabelToFinishLoading:(NSString *)label{
    return [KIFTestStep stepWithDescription:@"Waiting for a webview to finish loading..." executionBlock:^(KIFTestStep *step, NSError **error){
        UIAccessibilityElement *element = [self _accessibilityElementWithLabel:label accessibilityValue:nil tappable:NO traits:UIAccessibilityTraitNone error:error];
        
        NSString *waitDescription = [NSString stringWithFormat:@"Waiting for presence of accessibility element with label \"%@\"", label];
        
        //wait for the presence of the view
        KIFTestWaitCondition(element, error, @"%@", waitDescription);
        
        //is this element a UIWebView
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement: element]; 
        BOOL isElementWebView = [view isKindOfClass:[UIWebView class]];
        KIFTestCondition(isElementWebView, error, @"View with accessibility label %@ is not a webview, but a %@!", label, NSStringFromClass([view class]));
        
        //wait for the webview to finish loading
        UIWebView *webView = (UIWebView *)view;
        KIFTestWaitCondition(![webView isLoading], error, @"Waiting for UIWebView instance with accessibility label %@...", label);
        
        
        return KIFTestStepResultSuccess;
    }];
}

+(id)stepToRunJavascript:(NSString *)javascript inWebViewWithAccessibilityLabel:(NSString *)label{
    return [self stepToRunJavascript:javascript inWebViewWithAccessibilityLabel:label expectedResult:nil];
}

+(id)stepToRunJavascript:(NSString *)javascript inWebViewWithAccessibilityLabel:(NSString *)label expectedResult:(NSString *)expectedResult{
    return [KIFTestStep stepWithDescription:@"Running some javascript on a view..." executionBlock:^(KIFTestStep *step, NSError **error){
        UIAccessibilityElement *element = [self _accessibilityElementWithLabel:label accessibilityValue:nil tappable:NO traits:UIAccessibilityTraitNone error:error];
        
        NSString *waitDescription = [NSString stringWithFormat:@"Waiting for presence of accessibility element with label \"%@\"", label];
        
        //wait for the presence of the view
        KIFTestWaitCondition(element, error, @"%@", waitDescription);
        
        //is this element a UIWebView?
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement: element]; 
        BOOL isElementWebView = [view isKindOfClass:[UIWebView class]];
        KIFTestCondition(isElementWebView, error, @"View with accessibility label %@ is not a webview, but a %@!", label, NSStringFromClass([view class]));
        
        //wait for the webview to finish loading
        UIWebView *webView = (UIWebView *)view;
        NSString *result = [webView stringByEvaluatingJavaScriptFromString:javascript];
        if (expectedResult != nil) {
            KIFTestCondition([expectedResult isEqualToString:result], error, @"Expected result %@, recieved %@", expectedResult, result);
        }
        
        return KIFTestStepResultSuccess;
    }];
}

+(id)stepToTapElementWithSelector:(NSString *)selector inWebViewWithAccessibilityLabel:(NSString *)label{
    return [KIFTestStep stepWithDescription:@"Tapping an element in a webview" executionBlock:^(KIFTestStep *step, NSError **error){
        UIAccessibilityElement *element = [self _accessibilityElementWithLabel:label accessibilityValue:nil tappable:NO traits:UIAccessibilityTraitNone error:error];
        
        NSString *waitDescription = [NSString stringWithFormat:@"Waiting for presence of accessibility element with label \"%@\"", label];
        
        //wait for the presence of the view
        KIFTestWaitCondition(element, error, @"%@", waitDescription);
        
        //is this element a UIWebView?
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement: element]; 
        BOOL isElementWebView = [view isKindOfClass:[UIWebView class]];
        KIFTestCondition(isElementWebView, error, @"View with accessibility label %@ is not a webview, but a %@!", label, NSStringFromClass([view class]));
        UIWebView *webView = (UIWebView *)view;
        
        //inject javascript if automation functions are missing
        NSString *javascriptCheckResult = [webView stringByEvaluatingJavaScriptFromString:@"$.fn.isTappable === undefined"];
        if ([javascriptCheckResult isEqualToString:@"true"]) {
            //inject javascripts
            NSArray *scriptNames = [NSArray arrayWithObjects:@"zepto.viewportposition", nil];
            
            NSEnumerator *scriptEnumerator = [scriptNames objectEnumerator];
            NSString *scriptName;
            
            while (scriptName = [scriptEnumerator nextObject]) {
                NSString *jsPath = [[NSBundle mainBundle] pathForResource:scriptName ofType:@"js"];
                NSString *injectedJavascript = [[NSString alloc] initWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:NULL];
                
                [webView stringByEvaluatingJavaScriptFromString:injectedJavascript];
            }

        }
        
        //wait for element to be tappable
        NSString *tappableCheckScript = [NSString stringWithFormat:@"$('%@').isTappable()", selector];
        NSString *tappableCheckResult = [webView stringByEvaluatingJavaScriptFromString:tappableCheckScript];
        
        KIFTestWaitCondition([tappableCheckResult isEqualToString:@"true"], error, @"Timed out waiting for element at selector %@ to be tappable", selector);
        
        //get element position and tap the webview
        NSString *positionScript = [NSString stringWithFormat:@"JSON.stringify($('%@').viewportPosition())", selector];
        NSString *positionResult = [webView stringByEvaluatingJavaScriptFromString:positionScript];
        
        SBJsonParser *parser = [SBJsonParser new];
        NSDictionary *positionDictionary = [parser objectWithString:positionResult];
        [parser release];
        
        KIFTestCondition(positionDictionary != nil, error, @"Did not get a valid position for element at selector %@", selector);
        
        //tap the view
        CGFloat tapX = [[positionDictionary valueForKey:@"x"] floatValue];
        CGFloat tapY = [[positionDictionary valueForKey:@"y"] floatValue];
        CGPoint tapPoint = CGPointMake(tapX, tapY);
        [webView tapAtPoint:tapPoint];
        
        return KIFTestStepResultSuccess;
        
    }];
}

+ (id)stepToClearTextFromViewWithAccessibilityLabel:(NSString *)label{
    NSString *description = [NSString stringWithFormat:@"Clear the text from the view with accessibility label \"%@\"", label];
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        UIAccessibilityElement *element = [self _accessibilityElementWithLabel:label accessibilityValue:nil tappable:YES traits:UIAccessibilityTraitNone error:error];
        if (!element) {
            return KIFTestStepResultWait;
        }
        
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Cannot find view with accessibility label \"%@\"", label);
        
        CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:view];
        CGPoint tappablePointInElement = [view tappablePointInRect:elementFrame];
        
        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        KIFTestCondition(!isnan(tappablePointInElement.x), error, @"The element with accessibility label %@ is not tappable", label);
        [view tapAtPoint:tappablePointInElement];
        
        KIFTestWaitCondition([view isDescendantOfFirstResponder], error, @"Failed to make the view with accessibility label \"%@\" the first responder. First responder is %@", label, [[[UIApplication sharedApplication] keyWindow] firstResponder]);
        
        // Wait for the keyboard
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
        
        NSString *currentText = ([view respondsToSelector:@selector(text)])? [view performSelector:@selector(text)]: @"";
        
        for (NSUInteger characterIndex = 0; characterIndex < [currentText length]; characterIndex++) {
            NSString *characterString = @"\b";
            
            if (![self _enterCharacter:characterString]) {
                // Attempt to cheat if we couldn't find the character
                if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
                    NSLog(@"KIF: Unable to find keyboard key for %@. Inserting manually.", characterString);
                    [(UITextField *)view setText:[[(UITextField *)view text] stringByAppendingString:characterString]];
                } else {
                    KIFTestCondition(NO, error, @"Failed to find key for character \"%@\"", characterString);
                }
            }
        }
        
        return KIFTestStepResultSuccess;
    }];
}

+(id)stepToVerifyRewardUnlocked:(NSString *)reward quantity:(NSInteger)quantity{
    NSString *description = [NSString stringWithFormat:@"Verifying the last reward unlocked is %@ (quantity: %d)",reward,quantity];
    return [KIFTestStep stepWithDescription:description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
        PHReward *lastReward = [PHReward lastReward];
        
        KIFTestWaitCondition([reward isEqualToString:lastReward.name] && quantity == lastReward.quantity, error, @"Expected reward name: %@ (quantity: %d), but unlocked: %@ (quantity: %d)", reward, quantity, lastReward.name, lastReward.quantity);
        
        return KIFTestStepResultSuccess;
    }];
}

+(id)stepToVerifyLaunchURL:(NSString *)urlPath{
    NSString *description = [NSString stringWithFormat:@"Verifying the last URL launched is %@ ",urlPath];
    return [KIFTestStep stepWithDescription:description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
    
        NSURL *url = [PHURLLoader lastLaunchedURL];
        KIFTestWaitCondition([urlPath isEqualToString:[url absoluteString]],error,@"Expected launch URL: %@, but launched %@", urlPath, [url absoluteString]);
        
        return KIFTestStepResultSuccess;
    }];
}

+(id)steptoVerifyLaunchURLContainsHost:(NSString *)host{
    NSString *description = [NSString stringWithFormat:@"Verifying the last URL launched contains host: %@ ",host];
    return [KIFTestStep stepWithDescription:description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
        
        NSURL *url = [PHURLLoader lastLaunchedURL];
        NSString *hostString = [url host];
        KIFTestWaitCondition([hostString rangeOfString:host].location != NSNotFound,error,@"Expected launch URL to contain host: %@, but it was not present", host);
        
        return KIFTestStepResultSuccess;
    }];
}

+(id)stepToVerifyLaunchURLContainsParameter:(NSString *)parameter{
    NSString *description = [NSString stringWithFormat:@"Verifying the last URL launched contains parameter: %@ ",parameter];
    return [KIFTestStep stepWithDescription:description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
        
        NSURL *url = [PHURLLoader lastLaunchedURL];
        NSString *parameterString = [url parameterString];
        KIFTestWaitCondition([parameterString rangeOfString:parameter].location != NSNotFound,error,@"Expected launch URL to contain parameter: %@ but it was not present", parameter);
        
        return KIFTestStepResultSuccess;
    }];
}



+(id)stepToWaitForDispatch:(NSString *)dispatch{
    return [self stepToWaitForDispatch:dispatch andCallback:NO];
}

+(id)stepToWaitForDispatch:(NSString *)dispatch andCallback:(BOOL)waitForCallback {
    NSString *description = [NSString stringWithFormat:@"Waiting for a %@ dispatch",dispatch];
    return [KIFTestStep stepWithDescription:description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
        DispatchLog *foundDispatch = [PHContentView firstDispatch:dispatch];
        
        KIFTestWaitCondition(
                             foundDispatch != nil, error, @"Timed out waiting for dispatch: %@ !", dispatch);
        
        if (waitForCallback) {
            KIFTestWaitCondition(foundDispatch.isComplete, error, @"Timed out waiting for dispatch: %@ to call back!", dispatch);
        }
        
        //prevent this dispatch from getting matched again
        [[PHContentView _dispatchLog] removeObject:foundDispatch];

        return KIFTestStepResultSuccess;
    }];
    
}

@end
