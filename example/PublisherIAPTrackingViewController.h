//
//  PublisherIAPTrackingViewController.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 2/23/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExampleViewController.h"
#import "PlayHavenSDK.h"

@interface PublisherIAPTrackingViewController : ExampleViewController
@property (retain, nonatomic) IBOutlet UITextField *productField;
@property (retain, nonatomic) IBOutlet UITextField *quantityField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *resolutionSegment;
@end
