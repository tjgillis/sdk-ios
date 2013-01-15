//
//  PHContentView.h (formerly PHAdUnitView.h)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/1/11.
//  Copyright 2011 Playhaven. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <StoreKit/StoreKit.h>
#import "PHURLLoader.h"
@class PHContent;
@protocol PHContentViewDelegate;

//  Displays a content unit inside of a webview and manages content-template
//  dispatches and SDK callbacks between them. Also handles show/hide
//  transitions.
@interface PHContentView : UIView<UIWebViewDelegate, PHURLLoaderDelegate> {
    PHContent *_content;
    UIInterfaceOrientation _orientation;
    NSObject<PHContentViewDelegate> *_delegate;
    
    UIWebView *_webView;
    BOOL _willAnimate;
    
    NSMutableDictionary *_redirects;
    UIActivityIndicatorView *_activityView;
    UIView *_targetView;
}

//  To avoid the overhead of initialization, contentView instances may be
//  recycled using this status method once they have been dismissed.
+(void) enqueueContentViewInstance:(PHContentView *)contentView;

//  Returns a PHContentView instance if one has been enqueued, otherwise returns
//  nil.
+(PHContentView *) dequeueContentViewInstance;

//  Initializes a new PHContentView instance for the given PHContent.
-(id) initWithContent:(PHContent *)content;

//  Sets the PHContent instance for this view, PHContent defines the template,
//  transition, frame size, and context for this content unit.
@property(nonatomic, retain) PHContent *content;

//  Content view delegate
@property(nonatomic, assign) NSObject<PHContentViewDelegate> *delegate;

//  When shown, the content view will attempt to attach itself to this view.
//  Defaults to nil.
@property(nonatomic, assign) UIView *targetView;

//  Show the content unit, with animation. Loads the content template as well.
-(void) show:(BOOL)animated;

//  Dismiss the content unit, with animation.
-(void) dismiss:(BOOL)animated;

//  Special dismiss handler for native close button-initiated dismisses
-(void) dismissFromButton;

//  Assigns the dispatch URL |urlPath| to an invocation of the |action|
//  selectior on |target|. Replaces existing assignment if one already exists.
-(void) redirectRequest:(NSString *)urlPath toTarget:(id)target action:(SEL)action;

//  Returns response and/or error data to the content template for the callback
//  with id |callback|. Returns YES if the callback javascript executes without
//  throwing an exception.
-(BOOL) sendCallback:(NSString *)callback withResponse:(id)response error:(id)error;
@end

//  Delegates recieve messages about the state of the content view
@protocol PHContentViewDelegate<NSObject>
@optional

//  Content view was successfully displayed (-(void) show: completed)
-(void) contentViewDidShow:(PHContentView *)contentView;

//  Content view finished loading it's contents (UIWebView loaded event)
-(void) contentViewDidLoad:(PHContentView *)contentView;

//  Content view dismissed succesfully
-(void) contentViewDidDismiss:(PHContentView *)contentView;

//  Content view failed to display or load. |error| will be one of the PHError
//  types defined in PHConstants.h
-(void) contentView:(PHContentView *)contentView didFailWithError:(NSError *)error;

//  Customization delegate for changing the border color of content views with
//  a transition type of PH_DIALOG. Should return a UIColor instance.
-(UIColor *) borderColorForContentView:(PHContentView *)contentView;
@end
