//
//  PHStoreProductViewControllerDelegate.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 9/18/12.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@interface PHStoreProductViewControllerDelegate : NSObject<SKStoreProductViewControllerDelegate>
+(PHStoreProductViewControllerDelegate *)getDelegate;

-(void)showProductId:(NSString *)productId;
@end
