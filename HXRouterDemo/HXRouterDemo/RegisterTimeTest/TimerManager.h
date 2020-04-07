//
//  TimerManager.h
//  HXRouterDemo
//
//  Created by 周义进 on 2020/3/17.
//  Copyright © 2020 James. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXRouter.h"


@class TimerManager;

NS_ASSUME_NONNULL_BEGIN

#define TestHXMacroReigisterService(ServiceClass, ServiceURLString, NamespaceForService) \
@implementation HXRouter (ServiceClass##ServiceURLString##NamespaceForService) \
+ (void)load { \
    NSTimeInterval begin, end; \
    begin = CACurrentMediaTime(); \
    [[HXRouter sharedManager] registerService:[ServiceClass class] URLString:ServiceURLString serverNamespace:NamespaceForService]; \
    end = CACurrentMediaTime(); \
    [TimerManager sharedManager].testOfPreRegisterServiceNum += 1; \
    [TimerManager sharedManager].testOfPreRegisterDuration += end - begin; \
}\
\
@end \


@interface TimerManager : NSObject
@property (nonatomic, assign) NSTimeInterval   begin;
@property (nonatomic, assign) NSTimeInterval   end;

//测试 HXRouter 静态注册耗时(通过load)
@property (nonatomic, assign) NSInteger        testOfPreRegisterServiceNum;
@property (nonatomic, assign) NSTimeInterval   testOfPreRegisterDuration;

+ (instancetype)sharedManager;

- (void)showGlobalLoadDuration;
@end

NS_ASSUME_NONNULL_END
