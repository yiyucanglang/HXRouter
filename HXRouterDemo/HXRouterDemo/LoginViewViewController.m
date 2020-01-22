//
//  LoginViewViewController.m
//  HXRouterDemo
//
//  Created by James on 2020/1/22.
//  Copyright © 2020 James. All rights reserved.
//

#import "LoginViewViewController.h"

#import "HXRouteDemoServiceHeader.h"

HXMacroReigisterService(LoginViewViewController, URLString_ModuleLogin)

@interface LoginViewViewController ()

@end

@implementation LoginViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btns = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 80, 40)];
    [btns setTitle:@"登录成功" forState:UIControlStateNormal];
    btns.backgroundColor = [UIColor redColor];
    [btns addTarget:self action:@selector(loginSuccess) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btns];
}

- (void)loginSuccess {
    [self dismissViewControllerAnimated:YES completion:^{
           if (self.routeRequest.serviceCompletionHandler) {
               [self.routeRequest serviceCompletionHandlerWithResult:@(YES) error:nil userInfo:nil];
           }
    }];
}

@end
