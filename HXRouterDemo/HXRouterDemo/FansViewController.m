//
//  FansViewController.m
//  HXRouterDemo
//
//  Created by James on 2020/1/22.
//  Copyright © 2020 James. All rights reserved.
//

#import "FansViewController.h"

#import "HXRouteDemoServiceHeader.h"

HXMacroReigisterService(FansViewController, URLString_ModuleFan)

@interface FansViewController ()

@end

@implementation FansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UILabel *lb = [[UILabel alloc] initWithFrame:self.view.frame];
    lb.textColor = [UIColor whiteColor];
    lb.font = [UIFont systemFontOfSize:30];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = self.routeRequest.parameters[HXRouterTitleKey];
    [self.view addSubview:lb];
}


@end
