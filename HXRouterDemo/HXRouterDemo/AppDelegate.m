//
//  AppDelegate.m
//  HXRouterDemo
//
//  Created by James on 2020/1/22.
//  Copyright © 2020 James. All rights reserved.
//

#import "AppDelegate.h"
#import "TimerManager.h"
#import "HXRouteDemoServiceHeader.h"
@interface AppDelegate ()<HXRouterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TimerManager sharedManager].end = CACurrentMediaTime();
    NSLog(@"预注册服务数量:%@\n", @([TimerManager sharedManager].testOfPreRegisterServiceNum));
    //因为使用分类load注册，实际耗时会比下面数据大
    NSLog(@"预注册服务耗时:%.2f ms\n", [TimerManager sharedManager].testOfPreRegisterDuration * 1000);
    [[TimerManager sharedManager] showGlobalLoadDuration];
    
    [[HXRouter sharedManager] setRouterDelegate:self serverNamespace:HXRouterNamespace_RouterDemo];
    return YES;
}

- (NSString *)parserURLString:(NSString *)URLString {
    if ([URLString isEqualToString:URLString_PaperList]) {
        return URLString_ModuleA;
    }
    return URLString;
}

@end
