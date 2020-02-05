//
//  ModuleAViewController.m
//  HXRouterDemo
//
//  Created by James on 2020/1/22.
//  Copyright © 2020 James. All rights reserved.
//

#import "ModuleAViewController.h"

#import "HXRouteDemoServiceHeader.h"

HXMacroReigisterService(ModuleAViewController, URLString_ModuleA, HXRouterNamespace_RouterDemo)

@interface ModuleAViewController ()

@end

@implementation ModuleAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ModuleA";
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"parameters:%@", self.routeRequest.parameters);
}



@end
