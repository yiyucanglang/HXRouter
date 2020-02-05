//
//  HXRouter.m
//  JamesCreative
//
//  Created by James on 2020/1/13.
//  Copyright © 2020 James. All rights reserved.
//

#import "HXRouter.h"

#import <objc/runtime.h>
#import "HXRouterHandler.h"

static NSString * HXRoutePrivateFullPathKey = @"HXRoutePrivateFullPathKey";


@interface HXRouter()

@property (nonatomic, strong) NSMutableDictionary  *routeDic;
@property (nonatomic, strong) NSMutableDictionary *delegateDic;
@property (nonatomic, strong) dispatch_queue_t  routerSerialQueue;
@end

@implementation HXRouter


#pragma mark - Life Cycle
+ (instancetype)sharedManager {
    static HXRouter *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HXRouter alloc] init];
    });
    
    return manager;
}

#pragma mark - System Method

#pragma mark - Public Method
- (void)registerService:(id)service URLString:(NSString *)URLString serverNamespace:(NSString *)serverNamespace {
    HXSynRunInQueue(self.routerSerialQueue, ^{
        if (!URLString.length ||
            !service ||
            !serverNamespace.length ||
            !object_isClass(service)) {
            return;
        }

        NSURL *url = [NSURL URLWithString:URLString];
        if (!url) {
             NSString *desc = [NSString stringWithFormat:@"An error occurred. URLString can't convert to NSURL object!(service:%@ URLString:%@ serverNamespace:%@)", service, URLString, serverNamespace];
             NSAssert(0, desc);
             return;
        }
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        NSString *scheme = urlComponents.scheme.length > 0 ? urlComponents.scheme : @"";
        NSString *host   = urlComponents.host.length > 0 ? urlComponents.host : @"";
        NSString *path  = urlComponents.path.length > 0 ? urlComponents.path : @"";
        NSString *hostAndPath = [NSString stringWithFormat:@"%@%@", host, path];
        
        NSMutableDictionary *serverNamespaceDic = self.routeDic[serverNamespace];
        if (!serverNamespaceDic) {
            serverNamespaceDic = [NSMutableDictionary dictionary];
            self.routeDic[serverNamespace] = serverNamespaceDic;
        }
        
        
        if (!scheme.length && hostAndPath.length) {// fullpath
            NSMutableDictionary *fullPathDic = serverNamespaceDic[HXRoutePrivateFullPathKey];
            if (!fullPathDic) {
                fullPathDic = [NSMutableDictionary dictionary];
                serverNamespaceDic[HXRoutePrivateFullPathKey] = fullPathDic;
            }
            
            fullPathDic[hostAndPath] = service;
            return;
        }
        
        
        if (!hostAndPath.length) {
            NSString *desc = [NSString stringWithFormat:@"An error occurred. URLString must have host. (service:%@ URLString:%@ serverNamespace:%@) ps:For example, in the URL http://www.example.com/index.html, the host is www.example.com.", service, URLString, serverNamespace];
            NSAssert(0, desc);
            return;
        }
        
        
        NSMutableDictionary *schemeDic = serverNamespaceDic[scheme];
        if (!schemeDic) {
            schemeDic = [NSMutableDictionary dictionary];
            serverNamespaceDic[scheme] = schemeDic;
        }
        
        if (host.length && !path.length) {
            schemeDic[host] = service;
            return;
        }
        
        schemeDic[hostAndPath] = service;
        
    });
}

#pragma mark -
- (BOOL)canHandlerURLString:(NSString *)URLString serverNamespace:(nonnull NSString *)serverNamespace {
    
    __block BOOL canHandle = NO;
    HXSynRunInQueue(self.routerSerialQueue, ^{
        
        if (!URLString.length ||
            !serverNamespace.length) {
            canHandle = NO;
            return;
        }
        
        id<HXRouterDelegate> delegate = self.delegateDic[serverNamespace];
        BOOL delegateCanHandle = YES;
        if ([delegate respondsToSelector:@selector(canHandleURLString:)]) {
            delegateCanHandle = [delegate canHandleURLString:URLString];
        }
        if (!delegateCanHandle) {
            return;
        }
        
        if ([delegate respondsToSelector:@selector(handlerForURLString:)] && [delegate handlerForURLString:URLString]) {
            canHandle = YES;
            return;
        }
        
        
        NSString *parseredURLString = URLString;
        if ([delegate respondsToSelector:@selector(parserURLString:)]) {
            parseredURLString = [delegate parserURLString:URLString];
        }
        
        
        NSMutableDictionary *serverNamespaceDic = self.routeDic[serverNamespace];
        NSMutableDictionary *fullPathDic = serverNamespaceDic[HXRoutePrivateFullPathKey];
        
        if ([parseredURLString hasPrefix:@"http"]) {
            if (fullPathDic[HXRouteWebServiceURLString]) {
                canHandle = YES;
            }
            return;
        }
        
        NSURL *url = [NSURL URLWithString:parseredURLString];
        if (!url) {
            return;
        }
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        NSString *scheme = urlComponents.scheme.length > 0 ? urlComponents.scheme : @"";
        NSString *host   = urlComponents.host.length > 0 ? urlComponents.host : @"";
        NSString *path  = urlComponents.path.length > 0 ? urlComponents.path : @"";
        NSString *hostAndPath = [NSString stringWithFormat:@"%@%@", host, path];
        
        if (!scheme.length && hostAndPath.length) {//fullpath
            if (fullPathDic[hostAndPath]) {
                canHandle = YES;
            }
            return;
        }
        
        if (!hostAndPath.length) {
            return;
        }
        
        NSMutableDictionary *schemeDic = serverNamespaceDic[scheme];
        
        if (schemeDic[hostAndPath]) {
            canHandle = YES;
            return;
        }
        
        if (schemeDic[host]) {
            canHandle = YES;
        }
        
        
    });
    
    return canHandle;
}

#pragma mark -
- (id)getServiceEntityWithURLString:(NSString *)URLString serverNamespace:(nonnull NSString *)serverNamespace {
    return [self getServiceEntityWithURLString:URLString serverNamespace:serverNamespace nativeParameters:nil];
}

- (id)getServiceEntityWithURLString:(NSString *)URLString serverNamespace:(nonnull NSString *)serverNamespace nativeParameters:(NSDictionary * _Nullable)nativeParameters {
    return [self getServiceEntityWithURLString:URLString serverNamespace:serverNamespace nativeParameters:nativeParameters serviceCompletionHandler:nil];
}

- (id)getServiceEntityWithURLString:(NSString *)URLString serverNamespace:(nonnull NSString *)serverNamespace nativeParameters:(NSDictionary * _Nullable)nativeParameters serviceCompletionHandler:(HXServiceCompletionHandler _Nullable)serviceCompletionHandler {
    
    __block id service;
    __block NSURLComponents *outerURLComponents;
    __block NSString *parseredURLString = URLString;
    __block id<HXRouterDelegate> delegate = self.delegateDic[serverNamespace];
    HXSynRunInQueue(self.routerSerialQueue, ^{
        
        if (!URLString.length ||
            !serverNamespace.length) {
            return;
        }
        
        
        BOOL delegateCanHandle = YES;
        if ([delegate respondsToSelector:@selector(canHandleURLString:)]) {
            delegateCanHandle = [delegate canHandleURLString:URLString];
        }
        if (!delegateCanHandle) {
            return;
        }
        
        if ([delegate respondsToSelector:@selector(handlerForURLString:)]) {//delegate take over
            service = [delegate handlerForURLString:URLString];
            if (service) {
                return;
            }
        }
        
        
        if ([delegate respondsToSelector:@selector(parserURLString:)]) {
            parseredURLString = [delegate parserURLString:URLString];
        }
        
        
        NSMutableDictionary *serverNamespaceDic = self.routeDic[serverNamespace];
        NSMutableDictionary *fullPathDic = serverNamespaceDic[HXRoutePrivateFullPathKey];
        
        if ([parseredURLString hasPrefix:@"http"]) {
            service = fullPathDic[HXRouteWebServiceURLString];
            return;
        }
        
        
        
        NSURL *url = [NSURL URLWithString:parseredURLString];
        if (!url) {
            return;
        }
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        NSString *scheme = urlComponents.scheme.length > 0 ? urlComponents.scheme : @"";
        NSString *host   = urlComponents.host.length > 0 ? urlComponents.host : @"";
        NSString *path  = urlComponents.path.length > 0 ? urlComponents.path : @"";
        NSString *hostAndPath = [NSString stringWithFormat:@"%@%@", host, path];
        
        if (!scheme.length && hostAndPath.length) {
            service = fullPathDic[hostAndPath];
            return;
        }
        
        if (!hostAndPath.length) {
            return;
        }
        
        
        NSMutableDictionary *schemeDic = serverNamespaceDic[scheme];
        
        service = schemeDic[hostAndPath];
        if (service) {
            return;
        }
        
        service = schemeDic[host];
        
    });
    
    if (!service) {
        return nil;
    }
    
    HXRouterRequest *request;
    HXRouterHandler *handler;
    
    if([[service class] isSubclassOfClass:[UIViewController class]]) {
        
        handler = [[HXRouterHandler alloc] init];
        if ([delegate respondsToSelector:@selector(defaultRouterHandler)]) {
            id newHandler = [delegate defaultRouterHandler];
            handler = [[newHandler alloc] init];
        }
        
        request = [[HXRouterRequest alloc] initWithURLString:URLString parseredURLString:parseredURLString URLComponents:outerURLComponents natvieParameters:nativeParameters targetViewControllerClass:service serviceCompletionHandler:serviceCompletionHandler];
    }
    else {
        if (object_isClass(service)) {
            handler = [[service alloc] init];
        }
        else {
            handler = service;
        }
        request = [[HXRouterRequest alloc] initWithURLString:URLString parseredURLString:parseredURLString URLComponents:outerURLComponents natvieParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler];
    }
    
    NSError *error;
    if (![handler shouldHandleWithRequest:request error:&error]) {
        [request serviceCompletionHandlerWithResult:nil error:error userInfo:nil];
        return nil;
    }
    
    return [handler serviceWithRequest:request];
}

#pragma mark -
- (void)handleURLString:(NSString *)URLString serverNamespace:(nonnull NSString *)serverNamespace{
    [self handleURLString:URLString serverNamespace:serverNamespace nativeParameters:nil];
}

- (void)handleURLString:(NSString *)URLString serverNamespace:(nonnull NSString *)serverNamespace nativeParameters:(NSDictionary * _Nullable)nativeParameters {
    [self handleURLString:URLString serverNamespace:serverNamespace nativeParameters:nativeParameters serviceCompletionHandler:nil];
}

- (void)handleURLString:(NSString *)URLString serverNamespace:(nonnull NSString *)serverNamespace nativeParameters:(NSDictionary * _Nullable)nativeParameters serviceCompletionHandler:(HXServiceCompletionHandler _Nullable)serviceCompletionHandler {
    [self handleURLString:URLString serverNamespace:serverNamespace nativeParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler routerSearchCompletion:nil];
}

- (void)handleURLString:(NSString *)URLString serverNamespace:(NSString *)serverNamespace nativeParameters:(NSDictionary *)nativeParameters serviceCompletionHandler:(HXServiceCompletionHandler)serviceCompletionHandler routerSearchCompletion:(HXRouterSearchCompletion)routerSearchCompletion {
   
    HXSynRunInQueue(self.routerSerialQueue, ^{
            
        if (!URLString.length ||
            !serverNamespace.length) {
            NSAssert(0, @"An error occurred. URLString or serverNamespace may be nil");
            return;
        }
        
        id searchedService = nil;
        
        id<HXRouterDelegate> delegate = self.delegateDic[serverNamespace];
        
        BOOL delegateCanHandle = YES;
        if ([delegate respondsToSelector:@selector(canHandleURLString:)]) {
            delegateCanHandle = [delegate canHandleURLString:URLString];
        }
        if (!delegateCanHandle) {
            [self _routerSearchCompletion:routerSearchCompletion error:[NSError HXRouterServiceSearchCanceledByDelegate] userInfo:nil];
            return;
        }
        
        
        if ([delegate respondsToSelector:@selector(handlerForURLString:)]) {//delegate take over
           searchedService = [delegate handlerForURLString:URLString];
           if (searchedService) {
                [self _searchedService:searchedService URLString:URLString URLComponents:nil nativeParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler routerSearchCompletion:routerSearchCompletion delegate:delegate];
                return;
           }
        }
        
        
        NSString *parseredURLString = URLString;
        if ([delegate respondsToSelector:@selector(parserURLString:)]) {
            parseredURLString = [delegate parserURLString:URLString];
        }
        
        NSMutableDictionary *serverNamespaceDic = self.routeDic[serverNamespace];
        NSMutableDictionary *fullPathDic = serverNamespaceDic[HXRoutePrivateFullPathKey];
        
        if ([parseredURLString hasPrefix:@"http"]) {
            searchedService = fullPathDic[HXRouteWebServiceURLString];
            [self _searchedService:searchedService URLString:URLString URLComponents:nil nativeParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler routerSearchCompletion:routerSearchCompletion delegate:delegate];
            return;
        }
        
        
        NSURL *url = [NSURL URLWithString:parseredURLString];
        if (!url) {
            [self _routerSearchCompletion:routerSearchCompletion error:[NSError HXRouterErrorURLStringInvalid] userInfo:nil];
            return;
        }
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        NSString *scheme = urlComponents.scheme.length > 0 ? urlComponents.scheme : @"";
        NSString *host   = urlComponents.host.length > 0 ? urlComponents.host : @"";
        NSString *path  = urlComponents.path.length > 0 ? urlComponents.path : @"";
        NSString *hostAndPath = [NSString stringWithFormat:@"%@%@", host, path];
        
        if (!scheme.length && hostAndPath.length) {
            searchedService = fullPathDic[hostAndPath];
            [self _searchedService:searchedService URLString:URLString URLComponents:urlComponents nativeParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler routerSearchCompletion:routerSearchCompletion delegate:delegate];
            return;
        }
        
        if (!hostAndPath.length) {
            [self _routerSearchCompletion:routerSearchCompletion error:[NSError HXRouterErrorServiceNoFound] userInfo:nil];
            return;
        }
        
        
        NSMutableDictionary *schemeDic = serverNamespaceDic[scheme];
        
        searchedService = schemeDic[hostAndPath];
        if (!searchedService) {
            searchedService = schemeDic[host];
        }
        
        [self _searchedService:searchedService URLString:URLString URLComponents:urlComponents nativeParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler routerSearchCompletion:routerSearchCompletion delegate:delegate];
        
    });
    
}

- (void)setRouterDelegate:(id<HXRouterDelegate>)delegate serverNamespace:(NSString *)serverNamespace {
    HXAsyncRunInMain(^{
        if (!serverNamespace.length) {
            return;
        }
        self.delegateDic[serverNamespace] = delegate;
    });
}


#pragma mark - Private Method
- (void)_routerSearchCompletion:(HXRouterSearchCompletion)routeCompletion error:(NSError *)error userInfo:(NSDictionary *)userInfo {
    HXAsyncRunInMain(^{
        if (routeCompletion) {
            routeCompletion(error, userInfo);
        }
    });
}

- (void)_searchedService:(id)service
               URLString:(NSString *)URLString
           URLComponents:(NSURLComponents *)URLComponents
        nativeParameters:(NSDictionary *)nativeParameters
serviceCompletionHandler:(HXServiceCompletionHandler)serviceCompletionHandler
  routerSearchCompletion:(HXRouterSearchCompletion)routerSearchCompletion
                delegate:(id<HXRouterDelegate>)delegate {
    
    if (!service) {
        [self _routerSearchCompletion:routerSearchCompletion error:[NSError HXRouterErrorServiceNoFound] userInfo:nil];
        return;
    }
    HXAsyncRunInMain(^{
        
        HXRouterRequest *request;
        HXRouterHandler *handler;
        
        NSString *parseredURLString = URLString;
        if ([delegate respondsToSelector:@selector(parserURLString:)]) {
            parseredURLString = [delegate parserURLString:URLString];
        }
        
        if([[service class] isSubclassOfClass:[UIViewController class]]) {
            
            handler = [[HXRouterHandler alloc] init];
            if ([delegate respondsToSelector:@selector(defaultRouterHandler)]) {
                id newHandler = [delegate defaultRouterHandler];
                handler = [[newHandler alloc] init];
            }
            
            request = [[HXRouterRequest alloc] initWithURLString:URLString parseredURLString:parseredURLString URLComponents:URLComponents natvieParameters:nativeParameters targetViewControllerClass:service serviceCompletionHandler:serviceCompletionHandler];
        }
        else {
            
            if (object_isClass(service)) {
                handler = [[service alloc] init];
            }
            else {
                handler = service;
            }
            request = [[HXRouterRequest alloc] initWithURLString:URLString parseredURLString:parseredURLString URLComponents:URLComponents natvieParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler];
        }
        
        NSError *error;
        if (![handler shouldHandleWithRequest:request error:&error]) {
            [request serviceCompletionHandlerWithResult:nil error:error userInfo:nil];
            return;
        }
        
        [handler handleRequest:request];
        
    });
    
    [self _routerSearchCompletion:routerSearchCompletion error:nil userInfo:nil];
}

#pragma mark - Setter And Getter
- (NSMutableDictionary *)routeDic {
    if (!_routeDic) {
        _routeDic = [[NSMutableDictionary alloc] init];
    }
    return _routeDic;
}

- (NSMutableDictionary *)delegateDic {
    if (!_delegateDic) {
        _delegateDic = [[NSMutableDictionary alloc] init];
    }
    return _delegateDic;
}

- (dispatch_queue_t)routerSerialQueue {
    if (!_routerSerialQueue) {
        _routerSerialQueue = dispatch_queue_create("HXRouter.RouterQueue", NULL);
    }
    return _routerSerialQueue;
}

#pragma mark - Dealloc

@end
