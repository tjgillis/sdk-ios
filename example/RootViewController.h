//
//  RootViewController.h
//  example
//
//  Created by Jesus Fernandez on 4/25/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
    UITextField *tokenField;
    UITextField *secretField;
}

@property (nonatomic, retain) IBOutlet UITextField *tokenField;
@property (nonatomic, retain) IBOutlet UITextField *secretField;
@property (retain, nonatomic) IBOutlet UISwitch *optOutStatusSlider;
@property (retain, nonatomic) IBOutlet UILabel *serviceURLField;

-(void)touchedToggleStatusBar:(id)sender;
-(IBAction)touchedOptOutStatusSlider:(id)sender;

@end
