//
//  UIDevice+PlatformString.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/20/11.
//  Copyright 2011 Playhaven. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//  Category on UIDevice to find the hw.machine name of the current device
//  (iPhone4,1 for instance), special cases for handling simulator builds
//  TODO: Move this out of a category.
@interface UIDevice(HardwareString)
- (NSString *)hardware;
@end
