//
//  HXPaperHandler.m
//  HXRouterDemo
//
//  Created by James on 2020/1/22.
//  Copyright © 2020 James. All rights reserved.
//

#import "HXPaperHandler.h"

#import "HXRouteDemoServiceHeader.h"

#import "PaperListViewController.h"
#import "PaperDetailViewController.h"

HXMacroReigisterService(HXPaperHandler, URLString_Paper, HXRouterNamespace_RouterDemo)

@implementation HXPaperHandler

- (id)serviceWithRequest:(HXRouterRequest *)request {
    UIViewController  *service;
    if ([request.hostAndPath containsString:@"list"]) {
        service = [PaperListViewController new];
    }
    else {
        service = [PaperDetailViewController new];
    }
    service.routeRequest = request;
    return service;
}

@end
