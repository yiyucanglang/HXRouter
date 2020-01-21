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
@property (nonatomic, strong) NSMutableDictionary  *fullPathDic;

@property (nonatomic, strong) id  webService;

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
- (void)registerService:(id)service URLString:(NSString *)URLString {
    HXSynRunInQueue(self.routerSerialQueue, ^{
        
        if (!URLString.length) {
            return;
        }

        if (!object_isClass(service)) {
            return;
        }
        
        
        NSURL *url = [NSURL URLWithString:URLString];
        if (service && url) {
            
            NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
            
            NSString *scheme = urlComponents.scheme;
            NSString *host   = urlComponents.host;
            NSString *path  = urlComponents.path;
            NSMutableString *hostAndPath = [NSMutableString string];
            
            if (!scheme.length) {
                self.fullPathDic[URLString] = service;
                return;
            }
            
            if (host) {
                [hostAndPath appendString:host];
            }
            if (path) {
                [hostAndPath appendString:path];
            }
            
            
            NSMutableDictionary *schemeDic = self.routeDic[scheme];
            if (!schemeDic) {
                schemeDic = [NSMutableDictionary dictionary];
                self.routeDic[scheme] = schemeDic;
            }
            
            if ([path containsString:HXRouteURLStringSubServicePath]) {//子服务
                if (host.length && !schemeDic[host]) {
                    schemeDic[host] = service;
                    return;
                }
                
            }
            
            if (hostAndPath.length) {
                schemeDic[hostAndPath] = service;
            }
        
        }
        
    });
}

- (void)registerWebService:(id)service {
    HXSynRunInQueue(self.routerSerialQueue, ^{
        
        if (!object_isClass(service)) {
            return;
        }
        
        if (!self.webService) {
            self.webService = service;
        }
    });
}

#pragma mark -
- (BOOL)canHandlerURLString:(NSString *)URLString {
    
    __block BOOL canHandle = NO;
    HXSynRunInQueue(self.routerSerialQueue, ^{
       
        if (!URLString.length) {
            canHandle = NO;
            return;
        }
        
        if ([URLString hasPrefix:@"http"] || [URLString hasPrefix:@"https"]) {
            if (self.webService) {
                canHandle = YES;
            }
            return;
        }
        
        NSURL *url = [NSURL URLWithString:URLString];
        if (!url) {
            return;
        }
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        
        NSString *scheme = urlComponents.scheme;
        NSString *host   = urlComponents.host;
        NSString *path  = urlComponents.path;
        NSMutableString *hostAndPath = [NSMutableString string];
        
        if (!scheme.length) {
            if (self.fullPathDic[URLString]) {
                canHandle = YES;
            }
            return;
        }
        
        if (host) {
            [hostAndPath appendString:host];
        }
        if (path) {
            [hostAndPath appendString:path];
        }
        
        NSMutableDictionary *schemeDic = self.routeDic[scheme];
        
        if ([path containsString:HXRouteURLStringSubServicePath]) {//子模块
            if (schemeDic[host]) {
                canHandle = YES;
                return;
            }
            
        }
        
        if (schemeDic[hostAndPath]) {
            canHandle = YES;
        }
        
    });
    
    return canHandle;
}

#pragma mark -
- (id)getServiceEntityWithURLString:(NSString *)URLString {
    return [self getServiceEntityWithURLString:URLString nativeParameters:nil];
}

- (id)getServiceEntityWithURLString:(NSString *)URLString nativeParameters:(NSDictionary *)nativeParameters {
    return [self getServiceEntityWithURLString:URLString nativeParameters:nativeParameters serviceCompletionHandler:nil];
}

- (id)getServiceEntityWithURLString:(NSString *)URLString nativeParameters:(NSDictionary *)nativeParameters serviceCompletionHandler:(HXServiceCompletionHandler)serviceCompletionHandler {
    
    __block id service;
    __block NSURLComponents *outerURLComponents;
    HXSynRunInQueue(self.routerSerialQueue, ^{
        
        if (!URLString.length) {
            return;
        }
        
        if ([URLString hasPrefix:@"http"] || [URLString hasPrefix:@"https"]) {
            if (self.webService) {
                service = self.webService;
            }
            return;
        }
        
        NSURL *url = [NSURL URLWithString:URLString];
        if (!url) {
            return;
        }
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        outerURLComponents = urlComponents;
        
        NSString *scheme = urlComponents.scheme;
        NSString *host   = urlComponents.host;
        NSString *path  = urlComponents.path;
        NSMutableString *hostAndPath = [NSMutableString string];
        
        if (!scheme.length) {
            if (self.fullPathDic[URLString]) {
                service = self.fullPathDic[URLString];
            }
            return;
        }
        
        if (host) {
            [hostAndPath appendString:host];
        }
        if (path) {
            [hostAndPath appendString:path];
        }
        
        NSMutableDictionary *schemeDic = self.routeDic[scheme];
        
        if ([path containsString:HXRouteURLStringSubServicePath]) {//子模块
            if (schemeDic[host]) {
                service = schemeDic[host];
                return;
            }
            
        }
        
        if (schemeDic[hostAndPath]) {
            service = schemeDic[hostAndPath];
        }
    });
    
    if (!service) {
        return nil;
    }
    
    HXRouterRequest *request;
    HXRouterHandler *handler;
    
    if([[service class] isSubclassOfClass:[UIViewController class]]) {
        
        handler = [[HXRouterHandler alloc] init];
        if ([self.delegate defaultRouterHandler]) {
            id newHandler = [self.delegate defaultRouterHandler];
            handler = [[newHandler alloc] init];
        }
        
        request = [[HXRouterRequest alloc] initWithURLComponents:outerURLComponents natvieParameters:nativeParameters targetViewControllerClass:service serviceCompletionHandler:serviceCompletionHandler];
    }
    else {
        if ([service respondsToSelector:@selector(alloc)]) {
            handler = [[service alloc] init];
        }
        request = [[HXRouterRequest alloc] initWithURLComponents:outerURLComponents natvieParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler];
    }
    return [handler serviceWithRequest:request];
}

#pragma mark -
- (void)handleURLString:(NSString *)URLString {
    [self handleURLString:URLString nativeParameters:nil];
}

- (void)handleURLString:(NSString *)URLString nativeParameters:(NSDictionary *)nativeParameters {
    [self handleURLString:URLString nativeParameters:nativeParameters serviceCompletionHandler:nil];
}

- (void)handleURLString:(NSString *)URLString nativeParameters:(NSDictionary *)nativeParameters serviceCompletionHandler:(HXServiceCompletionHandler)serviceCompletionHandler {
    [self handleURLString:URLString nativeParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler routerSearchCompletion:nil];
}

- (void)handleURLString:(NSString *)URLString nativeParameters:(NSDictionary *)nativeParameters serviceCompletionHandler:(HXServiceCompletionHandler)serviceCompletionHandler routerSearchCompletion:(HXRouterSearchCompletion)routerSearchCompletion {
   
    HXSynRunInQueue(self.routerSerialQueue, ^{
            
        if (!URLString.length) {
            [self _routerSearchCompletion:routerSearchCompletion error:[NSError HXRouterErrorURLStringInvalid] userInfo:nil];
            return;
        }
        
        NSString *parserURLString = URLString;
        if ([self.delegate respondsToSelector:@selector(parserURLString:)]) {
            parserURLString = [self.delegate parserURLString:URLString];
        }
        
        if ([self.delegate respondsToSelector:@selector(shouldStopServiceSearchForURLString:)]) {
            [self _routerSearchCompletion:routerSearchCompletion error:[NSError HXRouterErrorDelegateAskStopServiceSerach] userInfo:nil];
            return;
        }
        
        
        NSURL *url = [NSURL URLWithString:parserURLString];
        if (!url) {
            [self _routerSearchCompletion:routerSearchCompletion error:[NSError HXRouterErrorURLStringInvalid] userInfo:nil];
            return;
        }
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        
        id searchedService = nil;
        if ([URLString hasPrefix:@"http"] || [URLString hasPrefix:@"https"]) {
            searchedService = self.webService;
            [self _searchedService:searchedService URLComponents:urlComponents nativeParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler routerSearchCompletion:routerSearchCompletion];
            return;
        }
        
        NSString *scheme = urlComponents.scheme;
        NSString *host   = urlComponents.host;
        NSString *path  = urlComponents.path;
        NSMutableString *hostAndPath = [NSMutableString string];
        
        if (!scheme.length) {
            searchedService = self.fullPathDic[URLString];
            [self _searchedService:searchedService URLComponents:urlComponents nativeParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler routerSearchCompletion:routerSearchCompletion];
            return;
        }
        
        if (host) {
            [hostAndPath appendString:host];
        }
        if (path) {
            [hostAndPath appendString:path];
        }
        
        NSMutableDictionary *schemeDic = self.routeDic[scheme];
        
        if ([path containsString:HXRouteURLStringSubServicePath]) {//子服务
            searchedService = schemeDic[host];
            [self _searchedService:searchedService URLComponents:urlComponents nativeParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler routerSearchCompletion:routerSearchCompletion];
            return;
            
        }
        
        searchedService = schemeDic[hostAndPath];
        [self _searchedService:searchedService URLComponents:urlComponents nativeParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler routerSearchCompletion:routerSearchCompletion];
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

- (void)_searchedService:(id)service URLComponents:(NSURLComponents *)URLComponents nativeParameters:(NSDictionary *)nativeParameters serviceCompletionHandler:(HXServiceCompletionHandler)serviceCompletionHandler routerSearchCompletion:(HXRouterSearchCompletion)routerSearchCompletion {
    
    if (!service) {
        [self _routerSearchCompletion:routerSearchCompletion error:[NSError HXRouterErrorServiceNoFound] userInfo:nil];
        return;
    }
    HXAsyncRunInMain(^{
        
        HXRouterRequest *request;
        HXRouterHandler *handler;
        
        if([[service class] isSubclassOfClass:[UIViewController class]]) {
            
            handler = [[HXRouterHandler alloc] init];
            if ([self.delegate defaultRouterHandler]) {
                id newHandler = [self.delegate defaultRouterHandler];
                handler = [[newHandler alloc] init];
            }
            
            
            request = [[HXRouterRequest alloc] initWithURLComponents:URLComponents natvieParameters:nativeParameters targetViewControllerClass:service serviceCompletionHandler:serviceCompletionHandler];
        }
        else {
            if ([service respondsToSelector:@selector(alloc)]) {
                handler = [[service alloc] init];
            }
            request = [[HXRouterRequest alloc] initWithURLComponents:URLComponents natvieParameters:nativeParameters serviceCompletionHandler:serviceCompletionHandler];
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

- (NSMutableDictionary *)fullPathDic {
    if (!_fullPathDic) {
        _fullPathDic = [[NSMutableDictionary alloc] init];
    }
    return _fullPathDic;
}

- (dispatch_queue_t)routerSerialQueue {
    if (!_routerSerialQueue) {
        _routerSerialQueue = dispatch_queue_create("HXRouter.RouterQueue", NULL);
    }
    return _routerSerialQueue;
}

#pragma mark - Dealloc

@end
