//
//  PHNetworkUtil.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 5/4/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>

// Singleton class with network-related utility functions
@interface PHNetworkUtil : NSObject

// Singleton accessor
+(id)sharedInstance;

//  Attempts to resolve DNS for the host at |urlpath|. Used to force populate the
//  DNS cache with PlayHaven API servers at app launch.
-(void)checkDNSResolutionForURLPath:(NSString *)urlPath;

//  Returns a retained CFDataRef instance with the current device's wifi MAC
//  address as a byte array. (Note: caller is responsible for CFReleasing this
//  instance.)
-(CFDataRef)newMACBytes;

//  Returns a string representation of a MAC address byte array |macBytes|
-(NSString *)stringForMACBytes:(CFDataRef)macBytes;
//  Returns ODIN1 representation (SHA1 hex diges) of a MAC address byte
//  array |macBytes|
-(NSString *)ODIN1ForMACBytes:(CFDataRef)macBytes;
@end
