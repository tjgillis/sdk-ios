//
//  IAPViewController.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 7/24/12.
//
//

#import "ExampleViewController.h"
#import <StoreKit/StoreKit.h>

@interface IAPViewController : ExampleViewController
@property (retain, nonatomic) IBOutlet UITextField *productField;
@property (retain, nonatomic) IBOutlet UITextField *quantityField;
@end
