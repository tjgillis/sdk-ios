//
//  PHPublisherIAPTrackingRequestTest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 2/24/2012.
//  Copyright 2012 Playhaven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "PlayHavenSDK.h"

@interface PHPublisherIAPTrackingRequestTest : SenTestCase
@end


@implementation PHPublisherIAPTrackingRequestTest

- (void)testConstructors
{
    PHPublisherIAPTrackingRequest *request;

    request = [PHPublisherIAPTrackingRequest requestForApp:@"APP" secret:@"SECRET"];
    STAssertNotNil(request, @"Expected request to exist!");


    NSString *product = @"com.playhaven.item";
    NSInteger quantity = 1;
    request = [PHPublisherIAPTrackingRequest requestForApp:@"APP"
                                                    secret:@"SECRET"
                                                   product:product
                                                  quantity:quantity
                                                resolution:PHPurchaseResolutionBuy
                                               receiptData:nil];
    STAssertNotNil(request, @"Expected request to exist!");

    request = [PHPublisherIAPTrackingRequest requestForApp:@"APP" secret:@"SECRET" product:product quantity:quantity error:PHCreateError(PHIAPTrackingSimulatorErrorType) receiptData:nil];
    STAssertNotNil(request, @"Expected request to exist!");
}

- (void)testCookie
{
    PHPublisherIAPTrackingRequest *request = [PHPublisherIAPTrackingRequest requestForApp:@"APP" secret:@"SECRET" product:@"PRODUCT" quantity:1 resolution:PHPurchaseResolutionBuy receiptData:nil];
    [request send];
    STAssertTrue([[request signedParameterString] rangeOfString:@"cookie"].location == NSNotFound, @"expected no cookie string parameterString: %@", [request signedParameterString]);
    [request cancel];

    [PHPublisherIAPTrackingRequest setConversionCookie:@"COOKIE" forProduct:@"PRODUCT"];

    PHPublisherIAPTrackingRequest *request2a = [PHPublisherIAPTrackingRequest requestForApp:@"APP" secret:@"SECRET" product:@"PRODUCT_OTHER" quantity:1 resolution:PHPurchaseResolutionBuy receiptData:nil];
    [request2a send];
    STAssertTrue([[request2a signedParameterString] rangeOfString:@"cookie"].location == NSNotFound, @"expected no cookie string parameterString: %@", [request2a signedParameterString]);
    [request2a cancel];

    PHPublisherIAPTrackingRequest *request2 = [PHPublisherIAPTrackingRequest requestForApp:@"APP" secret:@"SECRET" product:@"PRODUCT" quantity:1 resolution:PHPurchaseResolutionBuy receiptData:nil];
    [request2 send];
    STAssertTrue([[request2 signedParameterString] rangeOfString:@"cookie"].location != NSNotFound, @"expected cookie string parameterString: %@", [request2 signedParameterString]);
    [request2 cancel];

    PHPublisherIAPTrackingRequest *request3 = [PHPublisherIAPTrackingRequest requestForApp:@"APP" secret:@"SECRET" product:@"PRODUCT" quantity:1 resolution:PHPurchaseResolutionBuy receiptData:nil];
    [request3 send];
    STAssertTrue([[request3 signedParameterString] rangeOfString:@"cookie"].location == NSNotFound, @"cookie should only exist once! parameterString: %@", [request3 signedParameterString]);
    [request3 cancel];
}
@end
