//
//  PHPublisherContentRequest.h (formerly PHPublisherAdUnitRequest.h)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/5/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "PHAPIRequest.h"
#import "PHContentView.h"

@class PHPublisherContentRequest;
@class PHContent;
@class PHReward;
@class PHPurchase;
@protocol PHPublisherContentRequestDelegate;

//  Content request states in order from beginning to end. This is used to
//  support preloading new requests and continuing preloaded requests.
//    * PHPublisherContentRequestInitialized: default state
//    * PHPublisherContentRequestPreloading: API content request sent
//    * PHPublisherContentRequestPreloaded: API content request response
//      recieved
//    * PHPublisherContentRequestDisplayingContent: First content unit visible
//    * PHPublisherContentRequestDone: All content units have been dismissed
typedef enum {
    PHPublisherContentRequestInitialized,
    PHPublisherContentRequestPreloading,
    PHPublisherContentRequestPreloaded,
    PHPublisherContentRequestDisplayingContent,
    PHPublisherContentRequestDone
} PHPublisherContentRequestState;

//  Content request dismiss types are used in the
//  PHPublisherContentRequestDelegate method
//  -(void)request:(PHPublisherContentRequest *)request
//    contentDidDismissWithType:(PHPublisherContentDismissType *)type;
//  To explain what caused a content unit to be dismissed. It is not necessary
//  for implementations to use this information.
typedef NSString PHPublisherContentDismissType;
//  Request was dismissed with a content unit dismiss dispatch.
extern PHPublisherContentDismissType * const PHPublisherContentUnitTriggeredDismiss;
//  Request was dismissed by the user tapping the native close button.
extern PHPublisherContentDismissType * const PHPublisherNativeCloseButtonTriggeredDismiss;
//  Request was dismissed by the application entering the background
extern PHPublisherContentDismissType * const PHPublisherApplicationBackgroundTriggeredDismiss;
//  Request was dismissed before it was shown because the API response did not
//  contain a content unit.
extern PHPublisherContentDismissType * const PHPublisherNoContentTriggeredDismiss;

//  Request class for starting a content unit session. Manages the initial API
//  request, display of content unit, subcontent unit requests, native close
//  button, and overlay window.
@interface PHPublisherContentRequest : PHAPIRequest<PHContentViewDelegate, PHAPIRequestDelegate> {
    NSString *_placement;
    BOOL _animated;
    NSMutableArray *_contentViews;
    BOOL _showsOverlayImmediately;
    UIButton *_closeButton;

    UIView *_overlayWindow;
    PHContent *_content;

    PHPublisherContentRequestState _state;
    PHPublisherContentRequestState _targetState;
}

//  Returns a PHPublisherContentRequest instance for a given token secret and
//  placement. If a request was preloaded for the same placement, this method
//  will return that instance instead
+ (id)requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate;

//  Placement id for this content request, this should correspond to one of the
//  placements set up for this game on the PlayHaven Dashboard
@property (nonatomic,retain) NSString *placement;

//  Controls whether content unit transitions will be animated for this
//  request
@property (nonatomic,assign) BOOL animated;

//  Collection of PHContentViews being managed by this request
@property (nonatomic,readonly) NSMutableArray *contentViews;

//  Controls whether or not the overlay will be shown immediately after
//  - (void)send. Defaults to NO
@property (nonatomic, assign) BOOL showsOverlayImmediately;

//  Overlay view instance
@property (nonatomic, readonly) UIView *overlayWindow;

//  Request the content unit from the API, but stop before actually displaying
//  it until - (void)send is called
- (void)preload;
@end

//  Delegate protocol. Content request delegates will get notified at various
//  points in the content unit session.
@protocol PHPublisherContentRequestDelegate <NSObject>
@optional

//  A request is being sent to the API. Only sent for the first content unit
//  for a given request.
- (void)requestWillGetContent:(PHPublisherContentRequest *)request;

//  A response containing a valid content unit was received from the API. Only
//  sent for the first content unit for a given request.
- (void)requestDidGetContent:(PHPublisherContentRequest *)request;

//  The first content unit in the session is about to be shown
- (void)request:(PHPublisherContentRequest *)request contentWillDisplay:(PHContent *)content;

//  The first content unit in the session has been displayed
- (void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content;

//  Deprecated. The last content unit in the session has been dismissed
- (void)requestContentDidDismiss:(PHPublisherContentRequest *)request DEPRECATED_ATTRIBUTE;

//  The last content unit in the session has been dismissed. |type| will
//  specify a specific PHPublisherContentDismissType
- (void)request:(PHPublisherContentRequest *)request contentDidDismissWithType:(PHPublisherContentDismissType *)type;

//  The request encountered an error and cannot continue.
- (void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error;

//  Deprecated. The content unit encountered an error and cannot continue.
//  Errors that would have been sent here are now sent through the other
//  error delegate.
- (void)request:(PHPublisherContentRequest *)request contentDidFailWithError:(NSError *)error DEPRECATED_ATTRIBUTE;

#pragma mark - Content customization methods
//  Customization delegate. Replace the default native close button image with
//  a custom image for the given button state. Images should be smaller than
//  40x40 (screen coordinates)
- (UIImage *)request:(PHPublisherContentRequest *)request closeButtonImageForControlState:(UIControlState)state content:(PHContent *)content;

//  Customization delegate. Replace the default border color with a different
//  color for dialog-type content units.
- (UIColor *)request:(PHPublisherContentRequest *)request borderColorForContent:(PHContent *)content;

#pragma mark - Reward unlocking methods
//  A content unit delivers the reward specified in PHReward. Please consult
//  "Unlocking rewards with the SDK" in README.mdown for more information on
//  how to implement this delegate method.
- (void)request:(PHPublisherContentRequest *)request unlockedReward:(PHReward *)reward;

#pragma mark - Purchase unlocking methods
//  A content unit is initiating an IAP transaction. Please consult
//  "Triggering in-app purchases" in README.mdown for more information on
//  how to implement this delegate method.
- (void)request:(PHPublisherContentRequest *)request makePurchase:(PHPurchase *)purchase;
@end
