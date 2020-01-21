//
//  HXRouter.h
//  JamesCreative
//
//  Created by James on 2020/1/13.
//  Copyright © 2020 James. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXRouterHandler.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HXRouterSearchCompletion)(NSError * _Nullable error, NSDictionary * _Nullable userInfo);

@protocol HXRouterDelegate <NSObject>

@optional
/// This will invoke when the route begin search the avaiable  service, you can  modify URLString in this method
/// @param URLString  The URLString for  the  service
- (NSString *)parserURLString:(NSString *)URLString;


/// This will invoke when the route begin search the avaiable  service,  the router will stop serach when return  YES, you can check the URLString in this method
/// @param URLString The URLString for  the  service
- (BOOL)shouldStopServiceSearchForURLString:(NSString *)URLString;


/// Update router's  defaultRouterHandler
- (Class)defaultRouterHandler;

@end


/// Provides routing service registration and invocation
@interface HXRouter : NSObject


/// If you want to set delegate then you must do it as early as possible
@property (nonatomic, weak) id<HXRouterDelegate>   delegate;

+ (instancetype)sharedManager;

#pragma mark -
/// Register service to route
/// @param service Class for service
/// @param URLString The URLString for  the  service
- (void)registerService:(id)service URLString:(NSString *)URLString;

/// Register web service to route
/// @param service web service, this service is used to handle  web URLString(For example: https://www.baidu.com)
- (void)registerWebService:(id)service;

#pragma mark -
/// Check if the service is registered
/// @param URLString  The URLString for  the  service
- (BOOL)canHandlerURLString:(NSString *)URLString;


#pragma mark -
/// Get service entity by route
/// @param URLString The URLString for  the  service
- (id _Nullable)getServiceEntityWithURLString:(NSString *)URLString;

/// Get service entity by route
/// @param URLString The URLString for  the  service
/// @param nativeParameters The native parameters passed to the service
- (id _Nullable)getServiceEntityWithURLString:(NSString *)URLString nativeParameters:(NSDictionary * _Nullable)nativeParameters;

/// Get service entity by route
/// @param URLString The URLString for  the  service
/// @param nativeParameters The native parameters passed to the service
/// @param serviceCompletionHandler callback of service completion
- (id _Nullable)getServiceEntityWithURLString:(NSString *)URLString nativeParameters:(NSDictionary * _Nullable)nativeParameters serviceCompletionHandler:(HXServiceCompletionHandler _Nullable)serviceCompletionHandler;


#pragma mark -
/// Call the specified service
/// @param URLString The URLString for  the  service
- (void)handleURLString:(NSString *)URLString;

/// Call the specified service
/// @param URLString The URLString for  the  service
/// @param nativeParameters The native parameters passed to the service
- (void)handleURLString:(NSString *)URLString nativeParameters:(NSDictionary * _Nullable)nativeParameters;

/// Call the specified service
/// @param URLString The URLString for  the  service
/// @param nativeParameters The native parameters passed to the service
/// @param serviceCompletionHandler  callback of service completion
- (void)handleURLString:(NSString *)URLString nativeParameters:(NSDictionary * _Nullable)nativeParameters serviceCompletionHandler:(HXServiceCompletionHandler _Nullable)serviceCompletionHandler;

/// Call the specified service
/// @param URLString The URLString for  the  service
/// @param nativeParameters The native parameters passed to the service
/// @param serviceCompletionHandler  callback of service completion
/// @param routerSearchCompletion callback of route serch
- (void)handleURLString:(NSString *)URLString nativeParameters:(NSDictionary * _Nullable)nativeParameters serviceCompletionHandler:(HXServiceCompletionHandler _Nullable)serviceCompletionHandler routerSearchCompletion:(HXRouterSearchCompletion _Nullable)routerSearchCompletion;

@end

NS_ASSUME_NONNULL_END
