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

@interface KIFTestStep()
+ (UIAccessibilityElement *)_accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value tappable:(BOOL)mustBeTappable traits:(UIAccessibilityTraits)traits error:(out NSError **)error;
+ (BOOL)_enterCharacter:(NSString *)characterString;
@end

@implementation KIFTestStep (PHAdditions)
+(NSArray *)stepsToResetAppWithToken:(NSString *)token secret:(NSString *)secret{
    return [NSArray arrayWithObjects:
            [KIFTestStep stepWithDescription:@"Reset the app"
                              executionBlock:^(KIFTestStep *step, NSError **error) {
                                  //reset to home screen and set token and secret.
                                  
                                  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  [delegate.navigationController popToRootViewControllerAnimated:YES];
                                  
                                  return KIFTestStepResultSuccess;
                              }],
            [KIFTestStep stepToClearTextFromViewWithAccessibilityLabel:@"token"],
            [KIFTestStep stepToEnterText:token intoViewWithAccessibilityLabel:@"token"],
            [KIFTestStep stepToClearTextFromViewWithAccessibilityLabel:@"secret"],
            [KIFTestStep stepToEnterText:secret intoViewWithAccessibilityLabel:@"secret"],
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
        [webView stringByEvaluatingJavaScriptFromString:javascript];
        
        
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

@end
