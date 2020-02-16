//
//  HXRouterRequest.h
//  JamesCreative
//
//  Created by James on 2020/1/15.
//  Copyright © 2020 James. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HXServiceCompletionHandler)(id _Nullable resultData, NSError * _Nullable error, NSDictionary * _Nullable userInfo);

@interface HXRouterRequest : NSObject
@property (nonatomic, copy, readonly) NSString *URLString;
@property (nonatomic, copy, readonly) NSString *parseredURLString;
@property (nonatomic, copy, readonly) NSURLComponents  *URLComponents;

@property (nonatomic, copy, readonly) Class targetViewControllerClass;

/// URLQueryParameters + nativeParameters
@property (nonatomic, strong) NSDictionary  *parameters;

@property (nonatomic, copy, readonly) NSDictionary  *URLQueryParameters;
@property (nonatomic, copy, readonly) NSDictionary  *nativeParameters;
@property (nonatomic, copy, readonly) HXServiceCompletionHandler  serviceCompletionHandler;

@property (nonatomic, copy, readonly) NSString  *hostAndPath;


/// You can use this to store additional data in custom handler.
@property (nonatomic, strong) NSDictionary *userInfo;

- (instancetype)initWithURLString:(NSString *)URLString
                parseredURLString:(NSString *)parseredURLString
                    URLComponents:(NSURLComponents * _Nullable)URLComponents
                 natvieParameters:(NSDictionary * _Nullable)natvieParameters
         serviceCompletionHandler:(HXServiceCompletionHandler _Nullable)serviceCompletionHandler;

- (instancetype)initWithURLString:(NSString *)URLString
                parseredURLString:(NSString *)parseredURLString
                    URLComponents:(NSURLComponents * _Nullable)URLComponents
                 natvieParameters:(NSDictionary * _Nullable)natvieParameters
        targetViewControllerClass:(Class _Nullable)targetViewControllerClass
         serviceCompletionHandler:(HXServiceCompletionHandler _Nullable)serviceCompletionHandler;

- (void)serviceCompletionHandlerWithResult:(id _Nullable)result
                                error:(NSError * _Nullable)error
                              userInfo:(NSDictionary * _Nullable)userInfo;
@end

NS_ASSUME_NONNULL_END
