//
//  RouterModuleBHandler.m
//  HXRouterDemo
//
//  Created by James on 2020/1/22.
//  Copyright © 2020 James. All rights reserved.
//

#import "RouterModuleBHandler.h"

#import "HXRouteDemoServiceHeader.h"

#import "ModuleBViewController.h"

HXMacroReigisterService(RouterModuleBHandler, URLString_ModuleB)

@implementation RouterModuleBHandler

- (BOOL)shouldHandleWithRequest:(HXRouterRequest *)request error:(NSError *__autoreleasing  _Nullable *)error {
    
    //Simulate modueB requires login firstly
    [[HXRouter sharedManager] handleURLString:URLString_ModuleLogin nativeParameters:@{HXRouterModuleTransitioningStyleKey : @(HXModuleTransitioningStyle_Presenting)} serviceCompletionHandler:^(id  _Nullable resultData, NSError * _Nullable error, NSDictionary * _Nullable userInfo) {
        [self handleRequest:request];
    }];
    return NO;
}

- (id)serviceWithRequest:(HXRouterRequest *)request {
    ModuleBViewController *service = [ModuleBViewController new];
    service.routeRequest = request;
    return service;
}

@end
