//
//  PHPublisherOpenRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAPIRequest.h"

/**
 * @internal
 *
 * @brief Open request used to report the beginning of game sessions.
 **/
@interface PHPublisherOpenRequest : PHAPIRequest {
    NSString *_customUDID;
}

@property (nonatomic, copy) NSString *customUDID; /**< Publishers can attach an arbitrary user identifier to the open request by setting
                                                       this property. This will be appended to the request as a d_custom parameter. */
@end
