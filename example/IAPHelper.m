//
//  IAPHelper.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/2/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "IAPHelper.h"
#import "PlayHavenSDK.h"
#import "PHPurchase.h"

@interface UIAlertView(hash)
-(NSString *)hashString;
@end

@implementation UIAlertView(hash)

-(NSString *)hashString{
    return [NSString stringWithFormat:@"%d",[self hash]];
}

@end

static IAPHelper *sharedIAPHelper;

@implementation IAPHelper

+(IAPHelper *)sharedIAPHelper{
    @synchronized(self){
        if  (sharedIAPHelper == nil){
            sharedIAPHelper = [[super allocWithZone:NULL] init];
        }
    }
    return sharedIAPHelper;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedIAPHelper] retain];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}
- (oneway void)release {
    // never release
}
- (id)autorelease {
    return self;
}
- (void)dealloc {
    // Should never be called, but just here for clarity really.
    [_pendingPurchases release], _pendingPurchases = nil;
    [super dealloc];
}

#pragma mark -
-(NSMutableDictionary *)pendingPurchases{
    if (_pendingPurchases == nil) {
        _pendingPurchases = [[NSMutableDictionary alloc] init];
    }
    return _pendingPurchases;
}

-(void)startPurchase:(PHPurchase *)purchase{
    if (!!purchase) {
        NSString *message = [NSString stringWithFormat:@"Do you want to buy %d %@?",purchase.quantity,purchase.name];
        UIAlertView *purchaseAlert = [[UIAlertView alloc] initWithTitle:@"Confirm your in app purchase" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy", nil];
        [purchaseAlert show];        
        [self.pendingPurchases setObject:purchase forKey:[purchaseAlert hashString]];
        
        [purchaseAlert release];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    PHPurchase *purchase = (PHPurchase *)[self.pendingPurchases objectForKey:[alertView hashString]];
    PHPurchaseResolutionType resolution = PHPurchaseResolutionError;
    if (buttonIndex == 0) {
        NSLog(@"Canceled!");
        resolution = PHPurchaseResolutionCancel;
    } else if (buttonIndex == 1) {
        NSLog(@"Purchasing!");
        resolution = PHPurchaseResolutionBuy;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:@"ExampleToken"];
    NSString *secret = [defaults valueForKey:@"ExampleSecret"];
    
    //This is a hack to bypass the IAP product lookup while still doing something nice.
    PHPublisherIAPTrackingRequest *request = [PHPublisherIAPTrackingRequest requestForApp:token secret:secret product:purchase.productIdentifier quantity:purchase.quantity resolution:resolution];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:@"0.99"];
    NSLocale *locale = [NSLocale currentLocale];
    [request performSelector:@selector(sendWithPrice:andLocale:) withObject:decimalNumber withObject:locale];
    
    //Reporting back to the content unit.
    [purchase reportResolution:resolution];
    
}

@end
