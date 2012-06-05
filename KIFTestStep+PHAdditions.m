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

@interface KIFTestStep()
+ (UIAccessibilityElement *)_accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value tappable:(BOOL)mustBeTappable traits:(UIAccessibilityTraits)traits error:(out NSError **)error;
@end

@implementation KIFTestStep (PHAdditions)
+(id)stepToResetWithToken:(NSString *)token secret:(NSString *)secret{
    return [KIFTestStep stepWithDescription:@"Resetting the app and setting token and secret..."
                             executionBlock:^(KIFTestStep *step, NSError **error) {
                                 //reset to home screen and set token and secret.
                                 
                                 AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                 [delegate.navigationController popToRootViewControllerAnimated:YES];
                                 
                                 RootViewController *viewContoller = (RootViewController *)[delegate.navigationController topViewController];
                                 viewContoller.tokenField.text = token;
                                 viewContoller.secretField.text = secret;
                                 
                                 return KIFTestStepResultSuccess;
                             }];
    

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

@end
