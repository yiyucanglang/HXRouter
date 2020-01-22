//
//  HXRouterRegularExpression.h
//  JamesCreative
//
//  Created by James on 2020/1/15.
//  Copyright © 2020 James. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define HXMacroReigisterService(ServiceClass, ServiceURLString) \
@implementation HXRouter (ServiceClass##ServiceURLString) \
+ (void)load { \
    [[HXRouter sharedManager] registerService:[ServiceClass class] URLString:ServiceURLString]; \
}\
\
@end \


static NSString * HXRouteURLStringSubServicePath = @"subservice";


static NSString const * HXRouterModuleTransitioningStyleKey = @"transitioningStyle";
static NSString const * HXRouterIDKey               = @"id";
static NSString const * HXRouterTitleKey            = @"title";
static NSString const * HXRouterNameKey             = @"name";
static NSString const * HXRouterCustomKey           = @"custom";
static NSString const * HXRouterModuelNeedModelKey   = @"model";
static NSString const * HXRouterUserInfoKey         = @"userinfo";
static NSString const * HXRouterClientKey           = @"client";
static NSString const * HXRouterSubModuleIDKey       = @"submoduleid";
static NSString const * HXRouterProtocolKey         = @"protocol";


static NSString const * HXRouterBlockKey = @"block";


FOUNDATION_EXPORT NSString * const HXRouterErrorDomain;

typedef NS_ENUM(NSInteger, HXRouterModuleTransitioningStyle) {
   HXModuleTransitioningStyle_Pushing,
   HXModuleTransitioningStyle_Presenting,
   HXModuleTransitioningStyle_Custom
};

typedef void (^HXRouterRun)(void);

void HXAsyncRun(HXRouterRun run);
void HXAsyncRunInMain(HXRouterRun run);
void HXAsynRunInQueue(dispatch_queue_t queue, HXRouterRun run);
void HXSynRunInQueue(dispatch_queue_t queue, HXRouterRun run);

#pragma mark -
typedef NS_ENUM(NSInteger, HXRouterError) {
    
    HXRouterErrorModuleURLStringInvalid = 95273,
    HXRouterErrorDelegateAskStopServiceSerach,
    HXRouterErrorModuleNoFound,
    
};

@interface NSError (HXRouterError)

+(NSError *)HXRouterErrorURLStringInvalid;
+(NSError *)HXRouterErrorDelegateAskStopServiceSerach;
+(NSError *)HXRouterErrorServiceNoFound;

@end

NS_ASSUME_NONNULL_END
