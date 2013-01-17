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

//  Request for handling subcontent requests during a PHPublisherContentRequest
//  session. Subcontent requests require a fully qualified and presigned content
//  request URL.
@interface PHPublisherSubContentRequest : PHAPIRequest {
    PHContentView *_source;
    NSString *_callback;
}

//  Originating content view instance
@property (nonatomic, assign) PHContentView *source;

//  Originating callback id
@property (nonatomic, copy) NSString *callback;
@end
