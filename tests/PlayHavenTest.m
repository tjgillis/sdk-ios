//
//  PlayHavenTest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 5/22/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface PlayHavenTest : SenTestCase

@end

@implementation PlayHavenTest

@end

#include <stdio.h>
// Prototype declarations
FILE *fopen$UNIX2003( const char *filename, const char *mode );
size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d );

FILE *fopen$UNIX2003( const char *filename, const char *mode ) {
    return fopen(filename, mode);
}
size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d ) {
    return fwrite(a, b, c, d);
}