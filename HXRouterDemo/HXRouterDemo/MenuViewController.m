//
//  MenuViewController.m
//  HXRouterDemo
//
//  Created by James on 2020/1/22.
//  Copyright © 2020 James. All rights reserved.
//

#import "MenuViewController.h"

#import "HXRouteDemoServiceHeader.h"

#import "HXSegmentView.h"

HXMacroReigisterService(MenuViewController, URLString_ModuleMenu, HXRouterNamespace_RouterDemo)


@interface MenuViewController ()
@property (nonatomic, strong) UIViewController  *favoutiteVC;
@property (nonatomic, strong) UIViewController  *fanVC;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HXSegmentView *segmenView = [[HXSegmentView alloc] initWithFrame:CGRectMake(0, 0, 174, 30) titleArr:@[@"收藏", @"粉丝"]];
    segmenView.delegate = (id<HXConvenientViewDelegate>)self;
    self.navigationItem.titleView = segmenView;
    
    [self addChildViewController:self.favoutiteVC];
    [self.view addSubview:self.favoutiteVC.view];
    [self.favoutiteVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark HXSegmentView
- (void)handleHXSegmentViewAction:(NSInteger)actionType userInfo:(NSDictionary *)userInfo view:(HXSegmentView *)view {
    if ([userInfo[indexKey] integerValue] == 0) {//收藏
        [self.view bringSubviewToFront:self.favoutiteVC.view];
        return;
    }
    else {
        
        if (!self.fanVC.view.superview) {
            [self addChildViewController:self.fanVC];
            [self.view addSubview:self.fanVC.view];
            [self.fanVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
        [self.view bringSubviewToFront:self.fanVC.view];
        return;
    }
}

#pragma mark - Delegate


#pragma mark - Setter And Getter
- (UIViewController *)fanVC {
    if (!_fanVC) {
        _fanVC = [[HXRouter sharedManager] getServiceEntityWithURLString:URLString_ModuleFan serverNamespace:HXRouterNamespace_RouterDemo nativeParameters:@{HXRouterTitleKey : @"我的粉丝团"}];
    }
    return _fanVC;
}

- (UIViewController *)favoutiteVC {
    if (!_favoutiteVC) {
        _favoutiteVC = [[HXRouter sharedManager] getServiceEntityWithURLString:URLString_ModuleFavourite serverNamespace:HXRouterNamespace_RouterDemo];
    }
    return _favoutiteVC;
}

@end
