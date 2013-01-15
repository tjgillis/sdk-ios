//
//  PHURLLoader.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 2/9/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>

//  The maximum mumber of redirects to follow.
#define MAXIMUM_REDIRECTS 10

@protocol PHURLLoaderDelegate;

//  A class that opens a URL by first internally following
//  302 redirects until they have been exhausted or MAXIMUM_REDIRECTS redirects
//  have been followed. The loader may then open the final URL on the device.
//  Instances of PHURLLoader will retain themselves after open until they
//  launch or stop following redirects.
//  Used to prevent Safari from showing up when loading iTunes store links.
@interface PHURLLoader : NSObject {
    id <PHURLLoaderDelegate> _delegate;
    NSURLConnection *_connection;
    NSURL *_targetURL;
    NSInteger _totalRedirects;
    BOOL _opensFinalURLOnDevice;
    id _context;
}

//  Invalidates all loaders that have |delegate|
//  See -(void)invalidate for details
+(void)invalidateAllLoadersWithDelegate:(id <PHURLLoaderDelegate>) delegate;

//  Opens and returns PHURLLoader instance for the URL string |url|
+(PHURLLoader *)openDeviceURL:(NSString*)url;

//  The delegate, see PHURLLoaderDelegate for supported methods
@property (nonatomic, assign) id <PHURLLoaderDelegate> delegate;

//  The target URL, will be updated as redirects are followed
@property (nonatomic, retain) NSURL *targetURL;

//  Controls whether or not targetURL will be opened on the device.
//  Default YES.
@property (nonatomic, assign) BOOL opensFinalURLOnDevice;

//  Context object. Often used to pass along callback information for
//  dispatches. Default nil.
@property (nonatomic, retain) id context;

//  Follows redirects, starting with self.targetURL
-(void)open;

//  Stops following redirects and unassigns the delegate
-(void)invalidate;
@end

//  Delegate protocol for PHURLLoader instances.
@protocol PHURLLoaderDelegate<NSObject>
@optional

//  The loader has successfully finished following redirects and will proceed to
//  launch the URL on the device if self.opensFinalURLOnDevice is YES.
-(void)loaderFinished:(PHURLLoader *)loader;

//  The loader has failed to follow redirects (bad network connection, server
//  error) and will not launch a URL
-(void)loaderFailed:(PHURLLoader *)loader;
@end