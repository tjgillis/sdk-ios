//
//  PHNotificationRenderer.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/22/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


//  Base notification rendering class. This trivial implementation is used when
//  the type of notification being rendered is unknown, which will result in no
//  badge being rendered. See PHNotificationBadgeRenderer for a default badge
//  implementation.
@interface PHNotificationRenderer : NSObject

//  Subclasses should override this method and draw the notification represented
//  by |notificationData| in CGRect |rect|
-(void)drawNotification:(NSDictionary *)notificationData inRect:(CGRect)rect;

//  Subclasses should override this method and return the CGSize needed to draw
//  the notification represented by |notificationData|
-(CGSize)sizeForNotification:(NSDictionary *)notificationData;
@end
