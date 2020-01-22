//
//  HXRouterRequest.m
//  JamesCreative
//
//  Created by James on 2020/1/15.
//  Copyright © 2020 James. All rights reserved.
//

#import "HXRouterRequest.h"

@interface HXRouterRequest()

@property (nonatomic, copy) Class targetViewControllerClass;
@property (nonatomic, copy) NSURLComponents  *URLComponents;
@property (nonatomic, copy) NSDictionary  *URLQueryParameters;
@property (nonatomic, copy) NSDictionary  *nativeParameters;
@property (nonatomic, copy) HXServiceCompletionHandler  serviceCompletionHandler;

@end

@implementation HXRouterRequest
- (instancetype)initWithURLComponents:(NSURLComponents *)URLComponents natvieParameters:(NSDictionary *)natvieParameters serviceCompletionHandler:(HXServiceCompletionHandler)serviceCompletionHandler {
    return [self initWithURLComponents:URLComponents natvieParameters:natvieParameters targetViewControllerClass:nil serviceCompletionHandler:serviceCompletionHandler];
}

- (instancetype)initWithURLComponents:(NSURLComponents *)URLComponents natvieParameters:(NSDictionary *)natvieParameters targetViewControllerClass:(Class)targetViewControllerClass serviceCompletionHandler:(HXServiceCompletionHandler)serviceCompletionHandler {
    
    if (self = [super init]) {
        self.targetViewControllerClass = targetViewControllerClass;
        self.URLComponents = URLComponents;
        self.nativeParameters = natvieParameters;
        self.serviceCompletionHandler = serviceCompletionHandler;
    }
    return self;
}

- (void)serviceCompletionHandlerWithResult:(id)result error:(NSError *)error userInfo:(NSDictionary *)userInfo {
    if (self.serviceCompletionHandler) {
        self.serviceCompletionHandler(result, error, userInfo);
        self.serviceCompletionHandler = nil;
    }
   
}

- (NSDictionary *)parameters {
    if (!_parameters) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic addEntriesFromDictionary:self.URLQueryParameters];
        [dic addEntriesFromDictionary:self.nativeParameters];
        
        _parameters = [dic copy];
    }
    return _parameters;
}

- (NSDictionary *)URLQueryParameters {
    if (!_URLQueryParameters) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        for (NSURLQueryItem *item in self.URLComponents.queryItems) {
            dic[item.name] = item.value;
        }
        
        _URLQueryParameters = [dic copy];
    }
    return _URLQueryParameters;
}

- (NSString *)hostAndPath {
    NSString *host   = self.URLComponents.host;
    NSString *path  = self.URLComponents.path;
    NSMutableString *hostAndPath = [NSMutableString string];
    if (host) {
        [hostAndPath appendString:host];
    }
    if (path) {
        [hostAndPath appendString:path];
    }
    return hostAndPath;
}

@end
