//
//  PHNetworkUtil.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 5/4/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @internal
 *
 * @brief Singleton class with network-related utility functions
 **/
@interface PHNetworkUtil : NSObject

/**
 * Singleton accessor
 *
 * @return
 *   The shared instance
 **/
+ (id)sharedInstance;

/**
 * Attempts to resolve DNS for the host at \c urlPath. Used to force populate the
 * DNS cache with PlayHaven API servers at app launch
 *
 * @param urlPath
 *   The urlPath
 **/
- (void)checkDNSResolutionForURLPath:(NSString *)urlPath;

/**
 * Returns a retained CFDataRef instance with the current device's wifi MAC
 * address as a byte array.
 *
 * @return
 *   The retained CFDataRef instance
 *
 * @note
 * Caller is responsible for CFReleasing this instance
 **/
- (CFDataRef)newMACBytes;

/**
 * Returns a string representation of a MAC address byte array \c macBytes
 *
 * @param macBytes
 *   MAC address byte array
 *
 * @return
 *   A string representation of \c macBytes
 **/
- (NSString *)stringForMACBytes:(CFDataRef)macBytes;

/**
 * Returns ODIN1 representation (SHA1 hex digest) of a MAC address byte
 * array \c macBytes
 *
 * @param macBytes
 *   MAC address byte array
 *
 * @return
 *   An ODIN1 representation of \c macBytes
 **/
- (NSString *)ODIN1ForMACBytes:(CFDataRef)macBytes;
@end
