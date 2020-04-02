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
    //可以将RegisterTimeTest文件下的服务测试文件移除，看看耗时变化。
    printf("app load耗时粗略计算:  %.2f ms\n", (self.end - self.begin) * 1000);
}
@end
