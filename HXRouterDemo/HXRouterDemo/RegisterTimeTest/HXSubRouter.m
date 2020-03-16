//
//  HXSubRouter.m
//  HXRouterDemo
//
//  Created by 周义进 on 2020/3/17.
//  Copyright © 2020 James. All rights reserved.
//

#import "HXSubRouter.h"
#import "TimerManager.h"
@implementation HXSubRouter
+ (void)load {
    [TimerManager sharedManager].begin = CACurrentMediaTime();
}
@end
