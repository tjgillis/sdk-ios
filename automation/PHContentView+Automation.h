//
//  PHContentView+Automation.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/7/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//

#import "PHContentView.h"

@interface DispatchLog : NSObject
@property (nonatomic, copy) NSString *dispatch;
@property (nonatomic, copy) NSString *callback;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, assign) BOOL isComplete;
@end

@interface PHContentView (Automation)

+(NSMutableArray *)_dispatchLog;
+(DispatchLog *)firstDispatch:(NSString *)dispatch;
+(void)completeDispatchWithCallback:(NSString *)callback;
-(void)_logRedirectForAutomation:(NSString *)urlPath callback:(NSString *)callback;
-(void)_logCallbackForAutomation:(NSString *)callback;
@end
