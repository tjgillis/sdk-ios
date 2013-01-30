//
//  URLLoaderViewController.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 7/13/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "ExampleViewController.h"
#import "PHURLLoader.h"

@interface URLLoaderViewController : ExampleViewController <PHURLLoaderDelegate>
@property (retain, readonly)  PHURLLoader *loader;
@property (retain, nonatomic) IBOutlet UITextField *URLField;
@property (retain, nonatomic) IBOutlet UISwitch    *openURLSwitch;
@end
