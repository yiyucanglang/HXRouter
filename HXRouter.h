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

/// Ask the delegate whether can handle URLString, You can do something(check etc.) in this delegeate method.Return yes by default
/// @param URLString The URLString for the service

- (BOOL)canHandleURLString:(NSString *)URLString;

/// Ask the delegate to give the specified handler for URLString. If  the delegate return the handler then the router will stop. Return nil by default
/// @param URLString The URLString for the service
- (HXRouterHandler *)handlerForURLString:(NSString *)URLString;

/// Ask the delegate return the parsed URLString. You can do something(Add global parameters etc.) in this delegeate
/// @param URLString  The URLString for the service

- (NSString *)parserURLString:(NSString *)URLString;


/// Ask the delegate to set the router's default handler(Default:HXRouterHandler).

- (Class)defaultRouterHandler;

@end


/// Provides routing service registration and invocation
@interface HXRouter : NSObject

+ (instancetype)sharedManager;

#pragma mark -
/// Register service to route
/// @param service Class for service
/// @param URLString The URLString for the service
/// @param serverNamespace The serverNamespace of the service

- (void)registerService:(id)service URLString:(NSString *)URLString serverNamespace:(NSString *)serverNamespace;


#pragma mark -
/// Check if the service is registered
/// @param URLString  The URLString for the service
/// @param serverNamespace The serverNamespace of the service

- (BOOL)canHandlerURLString:(NSString *)URLString serverNamespace:(NSString *)serverNamespace;


#pragma mark -
/// Get service entity by route
/// @param URLString The URLString for the service
/// @param serverNamespace The serverNamespace of the service

- (id _Nullable)getServiceEntityWithURLString:(NSString *)URLString
                                    serverNamespace:(NSString *)serverNamespace;

/// Get service entity by route
/// @param URLString The URLString for the service
/// @param serverNamespace The serverNamespace of the service
/// @param nativeParameters The native parameters passed to the service

- (id _Nullable)getServiceEntityWithURLString:(NSString *)URLString
                                    serverNamespace:(NSString *)serverNamespace
                             nativeParameters:(NSDictionary * _Nullable)nativeParameters;

/// Get service entity by route
/// @param URLString The URLString for the service
/// @param serverNamespace The serverNamespace of the service
/// @param nativeParameters The native parameters passed to the service
/// @param serviceCompletionHandler callback of service completion

- (id _Nullable)getServiceEntityWithURLString:(NSString *)URLString
                                    serverNamespace:(NSString *)serverNamespace
                             nativeParameters:(NSDictionary * _Nullable)nativeParameters
                     serviceCompletionHandler:(HXServiceCompletionHandler _Nullable)serviceCompletionHandler;


#pragma mark -
/// Call the specified service
/// @param URLString The URLString for the service
/// @param serverNamespace The serverNamespace of the service

- (void)handleURLString:(NSString *)URLString serverNamespace:(NSString *)serverNamespace;

/// Call the specified service
/// @param URLString The URLString for the service
/// @param serverNamespace The serverNamespace of the service
/// @param nativeParameters The native parameters passed to the service

- (void)handleURLString:(NSString *)URLString
              serverNamespace:(NSString *)serverNamespace
       nativeParameters:(NSDictionary * _Nullable)nativeParameters;

/// Call the specified service
/// @param URLString The URLString for the service
/// @param serverNamespace The serverNamespace of the service
/// @param nativeParameters The native parameters passed to the service
/// @param serviceCompletionHandler  callback of service completion

- (void)handleURLString:(NSString *)URLString
              serverNamespace:(NSString *)serverNamespace
       nativeParameters:(NSDictionary * _Nullable)nativeParameters
serviceCompletionHandler:(HXServiceCompletionHandler _Nullable)serviceCompletionHandler;

/// Call the specified service
/// @param URLString The URLString for the service
/// @param serverNamespace The serverNamespace of the service
/// @param nativeParameters The native parameters passed to the service
/// @param serviceCompletionHandler  callback of service completion
/// @param routerSearchCompletion callback of route search

- (void)handleURLString:(NSString *)URLString
              serverNamespace:(NSString *)serverNamespace
       nativeParameters:(NSDictionary * _Nullable)nativeParameters
serviceCompletionHandler:(HXServiceCompletionHandler _Nullable)serviceCompletionHandler routerSearchCompletion:(HXRouterSearchCompletion _Nullable)routerSearchCompletion;


#pragma mark -
/// set delegate by serverNamespace
/// @param delegate delegate of router
/// @param serverNamespace The serverNamespace of the registered services
- (void)setRouterDelegate:(id<HXRouterDelegate>)delegate serverNamespace:(NSString *)serverNamespace;
@end

NS_ASSUME_NONNULL_END
