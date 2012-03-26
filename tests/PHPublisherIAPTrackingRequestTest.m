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

-(void)testConstructors{
    PHPublisherIAPTrackingRequest *request;
    
    request = [PHPublisherIAPTrackingRequest requestForApp:@"APP" secret:@"SECRET"];
    STAssertNotNil(request, @"Expected request to exist!");
    
    
    NSString *product = @"com.playhaven.item";
    NSInteger quantity = 1;
    request = [PHPublisherIAPTrackingRequest requestForApp:@"APP" 
                                                    secret:@"SECRET" 
                                                   product:product
                                                  quantity:quantity
                                                resolution:PHPurchaseResolutionBuy];
    STAssertNotNil(request, @"Expected request to exist!");
    
    request = [PHPublisherIAPTrackingRequest requestForApp:@"APP" secret:@"SECRET" product:product quantity:quantity error:PHCreateError(PHIAPTrackingSimulatorErrorType)];
    STAssertNotNil(request, @"Expected request to exist!");
}

@end