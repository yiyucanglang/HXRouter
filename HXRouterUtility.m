//
//  HXRouterRegularExpression.m
//  JamesCreative
//
//  Created by James on 2020/1/15.
//  Copyright © 2020 James. All rights reserved.
//

#import "HXRouterUtility.h"

void HXAsyncRun(HXRouterRun run) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        run();
    });
}

void HXAsyncRunInMain(HXRouterRun run) {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        run();
    });
}

void HXAsynRunInQueue(dispatch_queue_t queue, HXRouterRun run) {
    dispatch_async(queue, ^(void) {
        run();
    });
}

void HXSynRunInQueue(dispatch_queue_t queue, HXRouterRun run) {
    dispatch_sync(queue, ^(void) {
        run();
    });
}


#pragma mark -

NSString * const HXRouterErrorDomain = @"com.hxrouter.error";

@implementation NSError (HXRouterError)

+(NSError *)HXRouterErrorWithCode:(NSInteger)code message:(NSString *)message{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(message, nil) };
    return [NSError errorWithDomain:HXRouterErrorDomain code:code userInfo:userInfo];
}

+ (NSError *)HXRouterErrorURLStringInvalid {
    return  [self HXRouterErrorWithCode:HXRouterErrorModuleURLStringInvalid message:@" The URLString for the service is invalid。 if url contains illegal characters you must convert it user URLQueryAllowedCharacterSet"];
}

+ (NSError *)HXRouterErrorDelegateAskStopServiceSerach {
    return  [self HXRouterErrorWithCode:HXRouterErrorDelegateAskStopServiceSerach message:@" The route's delegate ask to stop service search"];
}

+ (NSError *)HXRouterErrorServiceNoFound {
    return [self HXRouterErrorWithCode:HXRouterErrorModuleNoFound message:@"The passed URLString does not match a registered service."];
}

@end

