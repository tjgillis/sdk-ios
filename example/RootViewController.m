//
//  RootViewController.m
//  example
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "RootViewController.h"
#import "PublisherOpenViewController.h"
#import "PublisherContentViewController.h"
#import "PublisherIAPTrackingViewController.h"
#import "PublisherCancelContentViewController.h"
#import "URLLoaderViewController.h"
#import "IAPViewController.h"
#import "PHAPIRequest.h"
#import "IDViewController.h"

@interface RootViewController(Private)
- (BOOL)isTokenAndSecretFilledIn;
- (void)loadTokenAndSecretFromDefaults;
- (void)saveTokenAndSecretToDefaults;
@end

@implementation RootViewController

+ (void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:@"ExampleToken"];
    NSString *secret = [defaults valueForKey:@"ExampleSecret"];

    if (PH_BASE_URL == nil || [PH_BASE_URL isEqualToString:@""]) {
        [defaults setValue:@"http://api2.playhaven.com" forKey:@"PHBaseUrl"];
    }

    if (token == nil || [token isEqualToString:@""]) {
        [defaults setValue:@"8ae979ddcdaf450996e897322169d26c" forKey:@"ExampleToken"];
    }

    if (secret == nil || [secret isEqualToString:@""]) {
        [defaults setValue:@"080d853e433a4468ba3315953b22615e" forKey:@"ExampleSecret"];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize tokenField;
@synthesize secretField;
@synthesize optOutStatusSlider;
@synthesize serviceURLField;

- (void)dealloc
{
    [tokenField release];
    [secretField release];
    [optOutStatusSlider release];
    [serviceURLField release];
    [super dealloc];
}

#pragma mark -
#pragma mark Private
- (BOOL)isTokenAndSecretFilledIn
{
    BOOL notNil = (self.tokenField.text && self.secretField.text);
    BOOL notEmpty = !( [self.tokenField.text isEqualToString:@""] || [self.secretField.text isEqualToString:@""] );

    return notNil && notEmpty;
}

- (void)loadTokenAndSecretFromDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];

    self.tokenField.text = [defaults valueForKey:@"ExampleToken"];
    self.secretField.text = [defaults valueForKey:@"ExampleSecret"];
    self.serviceURLField.text = PH_BASE_URL;

    self.optOutStatusSlider.on = [PHAPIRequest optOutStatus];
}

- (void)saveTokenAndSecretToDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setValue:self.tokenField.text forKey:@"ExampleToken"];
    [defaults setValue:self.secretField.text forKey:@"ExampleSecret"];

    [defaults synchronize];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"PlayHaven";

    UIBarButtonItem *toggleButton = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStyleBordered target:self action:@selector(touchedToggleStatusBar:)];
    self.navigationItem.rightBarButtonItem = toggleButton;
    [toggleButton release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadTokenAndSecretFromDefaults];
}

- (void)touchedToggleStatusBar:(id)sender
{
    BOOL statusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:!statusBarHidden withAnimation:UIStatusBarAnimationSlide];
    }

    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
}

- (IBAction)touchedOptOutStatusSlider:(id)sender
{
    [PHAPIRequest setOptOutStatus:self.optOutStatusSlider.on];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Open";
            cell.detailTextLabel.text = @"/publisher/open/";
            cell.accessibilityLabel = @"open";
            break;
        case 1:
            cell.textLabel.text = @"Content";
            cell.detailTextLabel.text = @"/publisher/content/";
            cell.accessibilityLabel = @"content";
            break;
        case 2:
            cell.textLabel.text = @"IAP Tracking";
            cell.detailTextLabel.text = @"";
            break;
        case 3:
            cell.textLabel.text = @"Cancelled Content";
            cell.detailTextLabel.text = @"This content will be cancelled at an awkward time.";
            break;
        case 4:
            cell.textLabel.text = @"URL Loader";
            cell.detailTextLabel.text = @"Test loading device URLs";
            cell.accessibilityLabel = @"url loader";
            break;
        case 5:
            cell.textLabel.text = @"IAP";
            cell.detailTextLabel.text = @"Test In-App Purchases";
            cell.accessibilityLabel = @"iap";
            break;
        case 6:
            cell.textLabel.text = @"identifiers";
            cell.detailTextLabel.text = @"all of them";
            cell.accessibilityLabel = @"identifiers";
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isTokenAndSecretFilledIn]) {
        [self saveTokenAndSecretToDefaults];
        if (indexPath.row == 0) {
            PublisherOpenViewController *controller = [[PublisherOpenViewController alloc] initWithNibName:@"PublisherOpenViewController" bundle:nil];
            controller.title = @"Open";
            controller.token = self.tokenField.text;
            controller.secret = self.secretField.text;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } else if (indexPath.row == 1) {
            PublisherContentViewController *controller = [[PublisherContentViewController alloc] initWithNibName:@"PublisherContentViewController" bundle:nil];
            controller.title = @"Content";
            controller.token = self.tokenField.text;
            controller.secret = self.secretField.text;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } else if (indexPath.row == 2) {
            PublisherIAPTrackingViewController *controller = [[PublisherIAPTrackingViewController alloc] initWithNibName:@"PublisherIAPTrackingViewController" bundle:nil];
            controller.title = @"IAP Tracking";
            controller.token = self.tokenField.text;
            controller.secret = self.secretField.text;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } else if (indexPath.row == 3) {
            PublisherCancelContentViewController *controller = [[PublisherCancelContentViewController alloc] initWithNibName:@"PublisherContentViewController" bundle:nil];
            controller.title = @"Content";
            controller.token = self.tokenField.text;
            controller.secret = self.secretField.text;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } else if (indexPath.row == 4) {
            URLLoaderViewController *controller = [[URLLoaderViewController alloc] initWithNibName:@"URLLoaderViewController" bundle:nil];
            controller.title = @"URL Loader";
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } else if (indexPath.row == 5) {
            IAPViewController *controller = [[IAPViewController alloc] initWithNibName:@"IAPViewController" bundle:nil];
            controller.title = @"IAP";
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } else if (indexPath.row == 6) {
            IDViewController *controller = [[IDViewController alloc] initWithNibName:@"IDViewController" bundle:nil];
            controller.title = @"Identifiers";
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Credentials" message:@"You must supply a PlayHaven API token and secret to use this app. To get a token and secret, please visit http://playhaven.com on your computer and sign up." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

}

- (void)viewDidUnload
{
    [self setTokenField:nil];
    [self setSecretField:nil];
    [self setOptOutStatusSlider:nil];
    [self setServiceURLField:nil];
    [super viewDidUnload];
}
@end
