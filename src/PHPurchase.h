//
//  PHPurchase.h
//  playhaven-sdk-ios
//
//  Created by Thomas DiZoglio on 1/12/12.
//  Copyright (c) 2012 Play Haven. All rights reserved.
//

#import <Foundation/Foundation.h>

/**

 PHPurchaseResolutionType
 ------------------------

 This is used to enumerate the different resolutions a particular purchase
 might have: 
 
    * PHPurchaseResolutionBuy ('buy'): the user was offered a purchasable 
        good and purchased it successfully
    * PHPurchaseResolutionCancel ('cancel'): the user was offered a good
        but did not choose to purchase it
    * PHPurchaseResolutionError ('error'): an error occurred during the 
        purchase process
    * PHPurchaseResolutionFailure ('failure'): the SDK was not able to
        confirm price and currency information for the good

**/
typedef enum{
    PHPurchaseResolutionBuy,
    PHPurchaseResolutionCancel,
    PHPurchaseResolutionError,
    PHPurchaseResolutionFailure
} PHPurchaseResolutionType;

//  Contains information about a IAP purchase that is usually triggered by a
//  ph://purchase dispatch in a content unit. Also provides a means for the
//  content unit to be informed of the resolution of this purchase request
@interface PHPurchase : NSObject{

    NSString *_productIdentifier;
    NSString *_item;
    NSInteger _quanity;
    NSString *_receipt;
    NSString *_callback;
}

//  Converts the enumerated resolution type to a string value for use in URL
//  parameter strings
+(NSString *)stringForResolution:(PHPurchaseResolutionType)resolution;

//  iTunes product identifier
@property (nonatomic, copy) NSString *productIdentifier;

//  product display name
@property (nonatomic, copy) NSString *name;

//  quantity of the item to purchase
@property (nonatomic, assign) NSInteger quantity;

//  unique receipt value to use for validation
@property (nonatomic, copy) NSString *receipt;

//  content unit callback identifier. (note: we're not passing a reference to
//  the originating content unit, this depends on callback ids being globally
//  unique.)
@property (nonatomic, copy) NSString *callback;

//  Reports the resolution of the purchase (see PHPurchaseResolutionType above)
//  to the content unit that originated the purchase.
-(void) reportResolution:(PHPurchaseResolutionType)resolution;

@end
