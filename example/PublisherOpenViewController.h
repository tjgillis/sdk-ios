//
//  PublisherOpenViewController.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExampleViewController.h"
#import "PlayHavenSDK.h"
#import "PHAPIRequest.h"

@interface PublisherOpenViewController : ExampleViewController<PHAPIRequestDelegate> {

}
@property (retain, nonatomic) IBOutlet UITextField *customUDIDField;

- (IBAction)touchedClearGID:(id)sender;
- (IBAction)touchedClearSession:(id)sender;
@end
