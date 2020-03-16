//
//  TimerManager.h
//  HXRouterDemo
//
//  Created by 周义进 on 2020/3/17.
//  Copyright © 2020 James. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerManager : NSObject
@property (nonatomic, assign) NSTimeInterval begin;
@property (nonatomic, assign) NSTimeInterval end;

+ (instancetype)sharedManager;

- (void)showDuration;
@end

NS_ASSUME_NONNULL_END
