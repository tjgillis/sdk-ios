//
//  URLLoaderViewController.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 7/13/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "URLLoaderViewController.h"

@interface URLLoaderViewController ()

@end

@implementation URLLoaderViewController
@synthesize loader = _loader;
@synthesize URLField;
@synthesize openURLSwitch;

- (PHURLLoader *)loader
{
    if (_loader == nil) {
        _loader = [PHURLLoader new];
    }

    return _loader;
}

- (void)dealloc
{
    [_loader invalidate];

    [_loader release], _loader = nil;
    [URLField release], URLField = nil;
    [openURLSwitch release], openURLSwitch = nil;;
    [super dealloc];
}

- (void)startRequest
{
    [super startRequest];

    //check to see if URL field has valid URL value
    NSURL *loaderURL = [NSURL URLWithString:self.URLField.text];
    if (loaderURL == nil) {
        //finish the request and report an error!
        [self addMessage:@"[ERROR] A valid URL was not entered!"];
        [self finishRequest];
    }

    //if we have a valid loader, then start the request!
    self.loader.targetURL = loaderURL;
    self.loader.opensFinalURLOnDevice = self.openURLSwitch.on;
    self.loader.delegate = self;

    [self.loader open];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)finishRequest
{
    [super finishRequest];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark -
#pragma PHURLLoaderDelegate

- (void)loaderFinished:(PHURLLoader *)loader
{
    NSString *message = [NSString stringWithFormat:@"[SUCCESS] Loader finished with URL: %@", loader.targetURL];
    [self addMessage:message];
    [self finishRequest];
}

- (void)loaderFailed:(PHURLLoader *)loader
{
    NSString *message = [NSString stringWithFormat:@"[FAIL] Loader failed to open at URL: %@", loader.targetURL];
    [self addMessage:message];
    [self finishRequest];
}
@end
