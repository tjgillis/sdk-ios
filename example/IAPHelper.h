//
//  IAPHelper.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/2/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
@class PHPurchase;
@interface IAPHelper : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    NSMutableDictionary *_pendingPurchases;
    NSMutableDictionary *_pendingRequests;
}

@property(nonatomic, readonly) NSMutableDictionary *pendingPurchases;
@property(nonatomic, readonly) NSMutableDictionary *pendingRequests;

+(IAPHelper *)sharedIAPHelper;

-(void)startPurchase:(PHPurchase *)purchase;
-(void)restorePurchases;
@end
