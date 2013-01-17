//
//  PHNotificationView.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/22/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHAPIRequest.h"
@class PHNotificationRenderer;
@class PHPublisherMetadataRequest;

//  View class that renders notification badges for placements. Uses
//  PHNotificationRenderer classes to allow publishers to customize the display
//  of notification badges without needing to subclass or handle additional
//  functionality. See "Customizing notification rendering with
//  PHNotificationRenderer" in the README for more on how that works.
@interface PHNotificationView : UIView<PHAPIRequestDelegate> {
    NSString *_app;
    NSString *_secret;
    NSString *_placement;

    NSDictionary *_notificationData;
    PHNotificationRenderer *_notificationRenderer;
    PHPublisherMetadataRequest *_request;
}

//  Set the specific PHNotificationRenderer subclass for the type. Currently only
//  "badge" is supported, but other types may be returned by the API in
//  the future
+ (void)setRendererClass:(Class)rendererClass forType:(NSString *)type;

//  Returns a new instance of the PHNotificationRenderer subclass for the
//  notification type indicated in |notificationData|
+ (PHNotificationRenderer *)newRendererForData:(NSDictionary *)notificationData;

//  Create a new notification view set up to make request using |token|,
//  |secret|, |placement|
- (id)initWithApp:(NSString *)app secret:(NSString *)secret placement:(NSString *)placement;

//  Getter/setter with notification data returned from the last request
//  to the API
@property (nonatomic,retain) NSDictionary *notificationData;

//  Retrieve latest notification data from the API and redraw the
//  notification view
- (void)refresh;

//  Deprecated to show a compiler warning, a test method that always returns a
//  notification badge with value "1" useful for positioning the badge on the
//  screen
- (void)test DEPRECATED_ATTRIBUTE;

//  Resets the notification data and hides the notification view
- (void)clear;
@end
