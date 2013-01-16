//
//  PHContent.h (formerly PHContent.h)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/31/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//  Content view transition type: currently two are supported.
//    * PHContentTransitionModal (PH_MODAL): full-screen modal view controller
//    that slides up from the bottom of the screen.
//    * PHContentTransitionDialog (PH_DIALOG): an arbitrarily sized and
//    positioned content unit view that 'pops' into view like an alert view
typedef enum{
    PHContentTransitionUnknown,
    PHContentTransitionModal,
    PHContentTransitionDialog
} PHContentTransitionType;

//  Content unit definition. This class separates out the usable components of
//  the content request response so that they can be used by other classes in the
//  SDK
@interface PHContent : NSObject {
    NSDictionary *_frameDict;
    NSURL *_URL;
    PHContentTransitionType _transition;
    NSDictionary *_context;
    NSTimeInterval _closeButtonDelay;
    NSString *_closeButtonURLPath;
}

//  Returns a PHContent instance iff the response dictionary
//  |dictionaryRepresentation| has valid values for all required keys, otherwise
//  returns nil
+(id)contentWithDictionary:(NSDictionary *)dictionaryRepresentation;

//  Content template URL
@property (nonatomic, retain) NSURL *URL;

//  Transition type, see PHContentTransitionType above
@property (nonatomic, assign) PHContentTransitionType transition;

//  Content unit context object, this is what is sent to the content template
//  after a ph://loadContext dispatch
@property (nonatomic, retain) NSDictionary *context;

//  Amount of time (in seconds) to wait after displaying the overlay before showing the native close button
@property (nonatomic, assign) NSTimeInterval closeButtonDelay;

//  The URL that should be pinged when the native close button is used
@property (nonatomic, copy) NSString *closeButtonURLPath;

//  Returns a CGRect if this content unit has a valid frame for |orientation|, otherwise returns CGRectNull
-(CGRect)frameForOrientation:(UIInterfaceOrientation)orientation;

//  Allows for manually setting the frameDict instance variable, values in
//  frameDict are used for
//  -(CGRect)frameForOrientation:(UIInterfaceOrientation)orientation
-(void)setFramesWithDictionary:(NSDictionary *)frameDict;


@end
