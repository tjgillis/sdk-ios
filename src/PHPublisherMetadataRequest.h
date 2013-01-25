//
//  PHPublisherMetadataRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/22/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAPIRequest.h"

/**
 * @internal
 *
 * @brief Request class for getting placement metadata for a specific placement.
 * Placement metadata is used to render notification views, for instance.
 **/
@interface PHPublisherMetadataRequest : PHAPIRequest {
    NSString *_placement;
}

/**
 * Returns a metadata request for a given placement
 *
 * @param token
 *   The token
 *
 * @param secret
 *   The secret
 *
 * @param placement
 *   The placement
 *
 * @param delegate
 *   The delegate
 *
 * @return
 *   A new request
 **/
+ (id)requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate;

@property (nonatomic,copy) NSString *placement; /**< The placement id for this request */
@end
