//
//  HXRouterHandler.m
//  JamesCreative
//
//  Created by James on 2020/1/15.
//  Copyright © 2020 James. All rights reserved.
//

#import "HXRouterHandler.h"

@implementation HXRouterHandler
- (BOOL)shouldHandleWithRequest:(HXRouterRequest *)request error:(NSError *__autoreleasing  _Nullable *)error {
    
    return YES;
}

- (id)serviceWithRequest:(HXRouterRequest *)request {
    UIViewController *targetViewController = [[request.targetViewControllerClass alloc] init];
    targetViewController.routeRequest = request;
    return targetViewController;
}

- (id)clientWithRequest:(HXRouterRequest *)request {
    
    if (request.parameters[HXRouterClientKey]) {
        return request.parameters[HXRouterClientKey];
    }
    
    UITabBarController *root =  (UITabBarController *)[[[UIApplication sharedApplication].delegate window] rootViewController];
    UINavigationController *navi;
    if ([root isKindOfClass:[UITabBarController class]]) {
        navi = root.selectedViewController;
    }
    else {
        navi = (UINavigationController *)root;
    }
    
    if ([navi isKindOfClass:[UINavigationController class]]) {
        return navi.visibleViewController;
    }
    return nil;
    
}

- (void)handleRequest:(HXRouterRequest *)request {
    
    UIViewController *clientViewController = [self clientWithRequest:request];
    UIViewController *serviceViewController = [self serviceWithRequest:request];
    
    if (!clientViewController ||
        !serviceViewController ||
        ![clientViewController isKindOfClass:[UIViewController class]] ||
        ![serviceViewController isKindOfClass:[UIViewController class]]
        ) {
        NSError *error = [NSError errorWithDomain:HXRouterErrorDomain code:96273 userInfo:@{ NSLocalizedDescriptionKey: NSLocalizedString(@"The default logic for handling routing requests can't execute because client or service may not available object(UIViewController) please check or register the custom handler", nil) }];
        [request serviceCompletionHandlerWithResult:nil error:error userInfo:nil];
        return;
    }
    
    
    HXRouterModuleTransitioningStyle moduleTransitioningStyle = HXModuleTransitioningStyle_Pushing;
    if (request.parameters[HXRouterModuleTransitioningStyleKey]) {
        moduleTransitioningStyle = [request.parameters[HXRouterModuleTransitioningStyleKey] integerValue];
    }
    
    if (moduleTransitioningStyle == HXModuleTransitioningStyle_Pushing) {
        [clientViewController.navigationController pushViewController:serviceViewController animated:YES];
        return;
    }
    
    if (moduleTransitioningStyle == HXModuleTransitioningStyle_Presenting) {
        [clientViewController.navigationController?:clientViewController presentViewController:serviceViewController animated:YES completion:nil];
        return;
    }
}

@end
