//
//  PHPublisherIAPTrackingRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 1/13/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#if PH_USE_STOREKIT!=0
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "PHAPIRequest.h"
#import "PHPurchase.h"

//  Request for reporting IAP transaction information to PlayHaven, used for user
//  segmentation and targeting by total in-app purchase spend.
//  Can track multiple resolutions of an attempted IAP transaction:
//    buy: an IAP item was offered and successfully purchased
//    cancel: an IAP item was offered but the user did not purchase
//    error: an IAP item was attempted to be offered but the device was not able
//      to  complete the transaction
//    failure: resolution in the case of an invalid IAP item or otherwise unable
//      to confirm the product id for this app
//  A delegate is not recommended for this request.
@interface PHPublisherIAPTrackingRequest : PHAPIRequest<SKProductsRequestDelegate>{
    NSString *_product;
    NSInteger _quantity;
    PHPurchaseResolutionType _resolution;
    SKProductsRequest *_request;
    NSError *_error;
    NSData *_receiptData;
}

//  Conversion cookie getter/setter
//  Conversion cookies are set by the SDK when a content unit initiates a
//  purchase through the purchase dispatch. (i.e: VGP content units), they are
//  used to track a potential IAP purchase and uniquely tag them as being a
//  VGP-driven conversion
+(void)setConversionCookie:(NSString *)cookie forProduct:(NSString *)product;
+(NSString *)getConversionCookieForProduct:(NSString *)product;

//  Returns a request to report a user buying or canceling an IAP product with
//  id |product|, for successful requests, also send iTunes receipt data so that
//  the API can independently verify the transaction
+(id)requestForApp:(NSString *)token secret:(NSString *)secret product:(NSString *)product quantity:(NSInteger)quantity resolution:(PHPurchaseResolutionType)resolution receiptData:(NSData *)receiptData;

//  Returns a request to report an IAP transaction that encountered an error
+(id)requestForApp:(NSString *)token secret:(NSString *)secret product:(NSString *)product quantity:(NSInteger)quantity error:(NSError *)error receiptData:(NSData *)receiptData;

//  Deprecated. Returns a request to report a user buying or canceling an
//  IAP product.
+(id)requestForApp:(NSString *)token secret:(NSString *)secret product:(NSString *)product quantity:(NSInteger)quantity resolution:(PHPurchaseResolutionType)resolution DEPRECATED_ATTRIBUTE;

//  Deprecated. Returns a request to report an IAP transcaction that encountered
//  an error.
+(id)requestForApp:(NSString *)token secret:(NSString *)secret product:(NSString *)product quantity:(NSInteger)quantity error:(NSError *)error DEPRECATED_ATTRIBUTE;

//  IAP bundle identifier string registered with Apple
@property (nonatomic, copy) NSString *product;

//  The total quantity purchased for this IAP transaction
@property (nonatomic, assign) NSInteger quantity;

//  The error encountered by this request, if applicable
@property (nonatomic, retain) NSError *error;

//  The resolution of this transaction (buy,cancel,error)
@property (nonatomic, assign) PHPurchaseResolutionType resolution;

//  iTunes transaction receipt data for this transaction
@property (nonatomic, retain) NSData *receiptData;

@end
#endif
