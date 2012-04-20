//
//  PublisherCancelContentViewController.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/20/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "PublisherCancelContentViewController.h"

@implementation PublisherCancelContentViewController

-(void)request:(PHPublisherContentRequest *)request contentWillDisplay:(PHContent *)content{
    if ([super respondsToSelector:@selector(request:contentWillDisplay:)]) {
        [super request:request contentWillDisplay:content];
    }
    
    [request cancel];
}
@end
