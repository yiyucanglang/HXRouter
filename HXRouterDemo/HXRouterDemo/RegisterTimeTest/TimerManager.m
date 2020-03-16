//
//  TimerManager.m
//  HXRouterDemo
//
//  Created by 周义进 on 2020/3/17.
//  Copyright © 2020 James. All rights reserved.
//

#import "TimerManager.h"

@implementation TimerManager
+ (instancetype)sharedManager {
    static TimerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TimerManager alloc] init];
    });
    return manager;
}

- (void)showDuration {
    printf("regist duration time:  %.2f ms\n", (self.end - self.begin) * 1000);
}
@end
