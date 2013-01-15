//
//  WWURLMatching.h
//  WaterWorks
//
//  Created by Jesus Fernandez on 1/31/12.
//

#import <Foundation/Foundation.h>

//  WWURLMatching is a utility class that calculates a matching level for two
//  URLS. Matching levels are used by WWURLConnection to select the best
//  substitute data based on the URL and query parameters. Matching is scored as
//  follows:
//    * If the URL scheme, host and path match, add 1 point, otherwise the
//      matching level is 0 (no match)
//      (eg. http://playhaven.com and http://betahaven.com are matching level 0)
//    * All parameters in |url2| MUST be present in |url1|, otherwise the
//      matching level is 0 (no match)
//    * Increment the matching level by 1 for each matching parameter.
@interface WWURLMatching : NSObject
//  Returns the matching level of |url1| with the target URL pattern |url2|
+(NSInteger)matchingLevelForURL:(NSURL *)url1 withURL:(NSURL *)url2;
@end
