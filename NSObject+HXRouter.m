//
//  NSObject+HXRouter.m
//  JamesCreative
//
//  Created by James on 2020/1/20.
//  Copyright © 2020 James. All rights reserved.
//

#import "NSObject+HXRouter.h"
#import <objc/runtime.h>

void *HXCategoryRouteRequest             = &HXCategoryRouteRequest;

@implementation NSObject (HXRouter)

- (void)setRouteRequest:(HXRouterRequest *)routeRequest {
    objc_setAssociatedObject(self, HXCategoryRouteRequest, routeRequest, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HXRouterRequest *)routeRequest {
    return objc_getAssociatedObject(self, HXCategoryRouteRequest);;
}

@end
