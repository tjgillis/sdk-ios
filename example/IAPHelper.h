//
//  IAPHelper.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/2/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PHPurchase;
@interface IAPHelper : NSObject{
    NSMutableDictionary *_pendingPurchases;
}

@property(nonatomic, readonly) NSMutableDictionary *pendingPurchases;

+(IAPHelper *)sharedIAPHelper;

-(void)startPurchase:(PHPurchase *)purchase;
@end
