//
//  IDViewController.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 12/17/12.
//
//

#import "IDViewController.h"
#import <AdSupport/AdSupport.h>
#import "PlayHavenSDK.h"
#import "PHNetworkUtil.h"


@interface IDViewController ()

@end

@implementation IDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    self.UDIDLabel.text = [[UIDevice currentDevice] uniqueIdentifier];
    self.IFALabel.text = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    CFDataRef macBytes = [[PHNetworkUtil sharedInstance] newMACBytes];
    self.MACLabel.text = [[PHNetworkUtil sharedInstance] stringForMACBytes:macBytes];
    self.ODIN1Label.text = [[PHNetworkUtil sharedInstance] ODIN1ForMACBytes:macBytes];
    CFRelease(macBytes);

    self.GIDLabel.text = PHGID();
    self.PHIDLabel.text = [PHAPIRequest session];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_UDIDLabel release];
    [_IFALabel release];
    [_MACLabel release];
    [_ODIN1Label release];
    [_GIDLabel release];
    [_PHIDLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setUDIDLabel:nil];
    [self setIFALabel:nil];
    [self setMACLabel:nil];
    [self setODIN1Label:nil];
    [self setGIDLabel:nil];
    [self setPHIDLabel:nil];
    [super viewDidUnload];
}
@end
