//
//  PHStoreProductViewControllerDelegate.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 9/18/12.
//
//

//  This will ensure the PH_USE_STOREKIT macro is properly set.
#import "PHConstants.h"

#if PH_USE_STOREKIT!=0
#import "PHStoreProductViewControllerDelegate.h"

static PHStoreProductViewControllerDelegate *_delegate = nil;

@implementation PHStoreProductViewControllerDelegate
+(PHStoreProductViewControllerDelegate *)getDelegate{
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_delegate == nil) {
            _delegate = [PHStoreProductViewControllerDelegate new];
        }
    });
	
	return _delegate;
}

@synthesize targetViewController = _targetViewController;


-(BOOL)showProductId:(NSString *)productId{
    if ([SKStoreProductViewController class]){
        SKStoreProductViewController *controller = [SKStoreProductViewController new];
        NSDictionary *parameters = [NSDictionary dictionaryWithObject:productId forKey:SKStoreProductParameterITunesItemIdentifier];
        controller.delegate = self;
        [controller loadProductWithParameters:parameters completionBlock:nil];
        
        [[self getVisibleViewController] presentModalViewController:controller animated:YES];
        [controller release];
        return true;
    }
    
    return false;
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissModalViewControllerAnimated:YES];
}


- (UIViewController *)getVisibleViewController {
    if (self.targetViewController != nil) {
        return self.targetViewController;
    }    
    
    UIViewController *viewController = nil;
    UIViewController *visibleViewController = nil;
    UIWindow *applicationWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    
    if ([applicationWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)applicationWindow.rootViewController;
        viewController = navigationController.visibleViewController;
    }
    else {
        viewController = applicationWindow.rootViewController;
    }
    
    while (visibleViewController == nil) {
        
        if (viewController.modalViewController == nil) {
            visibleViewController = viewController;
        } else {
            
            if ([viewController.modalViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigationController = (UINavigationController *)viewController.modalViewController;
                viewController = navigationController.visibleViewController;
            } else {
                viewController = viewController.modalViewController;
            }
        }
        
    }
    
    return visibleViewController;
}

@end
#endif