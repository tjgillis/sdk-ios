//
//  PHStoreProductViewControllerDelegate.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 9/18/12.
//
//
#if PH_USE_STOREKIT != 0

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@class SKStoreProductViewController;
@protocol SKStoreProductViewControllerDelegate;

/**
 * @internal
 *
 * @brief Singleton class that manages an overlay view controller, inserts it into the
 * application's UIWindow subviews, and uses it to display an
 * SKStoreProductViewController for a given iTunes product id.
 **/
@interface PHStoreProductViewControllerDelegate : NSObject <SKStoreProductViewControllerDelegate> {
    UIViewController *_visibleViewController;
}

/**
 * Singleton accessor
 **/
+ (PHStoreProductViewControllerDelegate *)getDelegate;

/**
 * Present an SKStoreProductViewController for the iTunes product with id \c productId
 *
 * @param productId
 *   The product ID
 *
 * @return
 *   Some kind of BOOL
 **/
- (BOOL)showProductId:(NSString *)productId;
@end
#endif
