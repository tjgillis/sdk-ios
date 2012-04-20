//
//  PublisherCancelContentViewController.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/20/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "PublisherCancelContentViewController.h"

static NSString *PublisherCancelContentViewControllerNotification = @"PublisherCancelContentViewControllerNotification";

@implementation PublisherCancelContentViewController

#pragma mark -
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(awkwardCancel) 
                                                 name:PublisherCancelContentViewControllerNotification
                                               object:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PublisherCancelContentViewControllerNotification object:self];
}

#pragma mark -
-(void)request:(PHPublisherContentRequest *)request contentWillDisplay:(PHContent *)content{
    if ([super respondsToSelector:@selector(request:contentWillDisplay:)]) {
        [super request:request contentWillDisplay:content];
    }
    
    NSNotification *cancelNotfication = [NSNotification notificationWithName:PublisherCancelContentViewControllerNotification
                                                                      object:self];
    [[NSNotificationQueue defaultQueue] enqueueNotification:cancelNotfication 
                                               postingStyle:NSPostASAP];
}

-(void)awkwardCancel{
    [self.request cancel];
    [self addMessage:@"Content Canceled!"];
    [self finishRequest];
}
@end
