//
//  AppDelegate.m
//  HXRouterDemo
//
//  Created by James on 2020/1/22.
//  Copyright © 2020 James. All rights reserved.
//

#import "AppDelegate.h"
#import "TimerManager.h"
#import <TTLoadTime/TTLoadTime.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TimerManager sharedManager].end = CACurrentMediaTime();
    [[TimerManager sharedManager] showDuration];
    printLoadCostsInfo();
    return YES;
}

@end
