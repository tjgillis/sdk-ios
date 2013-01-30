//
//  PHPublisherSubcontentRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 5/19/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAPIRequest.h"

@class PHContentView;

/**
 * @internal
 *
 * @brief Request for handling subcontent requests during a PHPublisherContentRequest
 * session. Subcontent requests require a fully qualified and presigned content
 * request URL.
 **/
@interface PHPublisherSubContentRequest : PHAPIRequest {
    PHContentView *_source;
    NSString      *_callback;
}

@property (nonatomic, assign) PHContentView *source;   /**< Originating content view instance */
@property (nonatomic, copy)   NSString      *callback; /**< Originating callback id */
@end
