//
//  PHPurchaseTest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 2/24/2012.
//  Copyright 2012 Playhaven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "PHPurchase.h"

@interface PHPurchaseTest : SenTestCase
@end

@implementation PHPurchaseTest

- (void)testResolutionStrings
{
    STAssertTrue([[PHPurchase stringForResolution:PHPurchaseResolutionBuy] isEqualToString:@"buy"], @"Expected 'buy' got %@",[PHPurchase stringForResolution:PHPurchaseResolutionBuy]);
    STAssertTrue([[PHPurchase stringForResolution:PHPurchaseResolutionCancel] isEqualToString:@"cancel"], @"Expected 'cancel' got %@",[PHPurchase stringForResolution:PHPurchaseResolutionCancel]);
    STAssertTrue([[PHPurchase stringForResolution:PHPurchaseResolutionError] isEqualToString:@"error"], @"Expected 'error' got %@",[PHPurchase stringForResolution:PHPurchaseResolutionError]);
    STAssertTrue([[PHPurchase stringForResolution:PHPurchaseResolutionFailure] isEqualToString:@"failure"], @"Expected 'failure' got %@",[PHPurchase stringForResolution:PHPurchaseResolutionFailure]);
}

@end
