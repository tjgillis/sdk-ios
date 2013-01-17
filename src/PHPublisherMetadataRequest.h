//
//  PHPublisherMetadataRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/22/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAPIRequest.h"

//  Request class for getting placement metadata for a specific placement.
//  Placement metadata is used to render notification views, for instance.
@interface PHPublisherMetadataRequest : PHAPIRequest {
    NSString *_placement;
}

//  Returns a metadata request for a given placement
+ (id)requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate;

//  The placement id for this request
@property (nonatomic,copy) NSString *placement;
@end
