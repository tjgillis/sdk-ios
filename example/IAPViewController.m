//
//  IAPViewController.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 7/24/12.
//
//

#import "IAPViewController.h"
#import "IAPHelper.h"
#import "PHPurchase.h"

@interface IAPViewController ()

@end

@implementation IAPViewController
@synthesize productField  = _productField;
@synthesize quantityField = _quantityField;

- (void)dealloc
{
    [_productField release], _productField = nil;
    [_quantityField release], _quantityField = nil;
    [super dealloc];
}

#pragma mark -
- (void)startRequest
{
    [super startRequest];

    PHPurchase *purchase = [PHPurchase new];

    purchase.productIdentifier = ([self.productField.text isEqualToString:@""]) ?
                                            @"com.playhaven.example.candy" :
                                            self.productField.text;
    purchase.quantity          = ([self.quantityField.text isEqualToString:@""]) ?
                                            1 : [self.quantityField.text integerValue];

    [[IAPHelper sharedIAPHelper] startPurchase:purchase];

    [purchase release];

    [super finishRequest];
}
@end
