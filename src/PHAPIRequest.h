//
//  PHAPIRequest.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#import <AdSupport/AdSupport.h>
#endif
#endif

@protocol PHAPIRequestDelegate;

//  Base class for API requests, generates valid request signatures based on the
//  device's GID, and checks for a valid X-PH-DIGEST response signature.
@interface PHAPIRequest : NSObject {
    NSURL *_URL;
    NSString *_token, *_secret;
    NSURLConnection *_connection;
    NSDictionary *_signedParameters;
    id<NSObject> _delegate;
    NSMutableData *_connectionData;
    NSString *_urlPath;
    NSDictionary *_additionalParameters;
    NSURLResponse *_response;
    int _hashCode;
}

//  Generates a URL-friendly b64 signature digest of |string|
+ (NSString *) base64SignatureWithString:(NSString *)string;

//  Generates the expected X-PH-DIGEST response signature based on the response body, nonce, and app secret
+ (NSString *) expectedSignatureValueForResponse:(NSString *)response nonce:(NSString *)nonce secret:(NSString *)secret;

//  Retrieves the PHID (otherwise known as the session token) from the pasteboard
//  This value is used for GID/PHID-based device identification
+ (NSString *) session;

//  Gets and sets the UDID opt-out status. If YES and
//  PH_USE_UNIQUE_IDENTIFIER==1, then the device's UDID will be sent with each
//  request. Defaults to YES.
+ (BOOL)optOutStatus;
+ (void)setOptOutStatus:(BOOL)yesOrNo;

//  Gets and sets the plugin identifier. Third party plugins based on the iOS SDK
//  should set this to a value that is unique for each plugin version.
//  Defaults to ios-PH_SDK_VERSION
+ (NSString *) pluginIdentifier;
+ (void)setPluginIdentifier:(NSString *)identifier;

//  Returns a new PHAPIRequest instance with the given token and secret
+ (id)requestForApp:(NSString *)token secret:(NSString *)secret;

//  Returns an existing request with a hashCode value of |hashCode|
//  Used by the Unity3d plugin.
+ (id)requestWithHashCode:(int)hashCode;

//  Cancels all requests for a given delegate, typically used when a view
//  controller is set as request delegate, and that view controller might be
//  dismissed by the user while there are active API requests.
+ (void)cancelAllRequestsWithDelegate:(id) delegate;

//  Cancels an existing request with a hashCode value of |hashCode|
//  Used by the Unity3d plugin.
+ (int)cancelRequestWithHashCode:(int)hashCode;


//  API token for this request, value is set during initialization
@property (nonatomic, readonly) NSString *token;

//  API secret for this request, value is set during initialization
@property (nonatomic, readonly) NSString *secret;

//  API endpoint to use for this request, subclasses will override this with
//  a hard-coded value
@property (nonatomic, copy) NSString *urlPath;

//  Subclasses can either override this implementation to add custom parameters
//  to requests
@property (nonatomic, retain) NSDictionary *additionalParameters;

//  Lazily-initialized dictionary of base request parameters as well as necessary
//  request signatures
@property (nonatomic, readonly) NSDictionary *signedParameters;

//  Lazily-initialized NSURL instance that contains a full request URL with
//  signed parameters
@property (nonatomic, readonly) NSURL *URL;

//  Request delegate, see PHAPIRequestDelegate
@property (nonatomic, assign) id<NSObject> delegate;

//  Unique hash code identifying this request. Used by the Unity3d plugin
@property (nonatomic, assign) int hashCode;

//  URL-encoded parameter string using keys and values in self.signedParameters
- (NSString *)signedParameterString;

//  Start the request if it has not already started
- (void)send;

//  Cancel the request if it has already started
- (void)cancel;
@end

//  Delegate protocol for getting information about API requests
@protocol PHAPIRequestDelegate <NSObject>
//  The |request| completed successfully, has a valid response signature and
//  returned |responseData|
- (void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData;

//  The |request| failed, |error| will either be a PHError instance (see
//  PHConstants.h) or a NSURLConnection error
- (void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error;
@end
