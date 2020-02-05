//
//  ViewController.m
//  HXRouterDemo
//
//  Created by James on 2020/1/22.
//  Copyright © 2020 James. All rights reserved.
//

#import "ViewController.h"

#import "HXRouteDemoServiceHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)openModuleA:(UIButton *)sender {
    [[HXRouter sharedManager] handleURLString:URLString_ModuleA serverNamespace:HXRouterNamespace_RouterDemo nativeParameters:@{ModuleA_StudentIDKey : @(22), ModuleA_StudentNameKey : @"张三"}];
}

- (IBAction)openModuleB:(UIButton *)sender {
    
    [[HXRouter sharedManager]  handleURLString:URLString_ModuleB serverNamespace:HXRouterNamespace_RouterDemo];
    
}
- (IBAction)openModuleMenu:(id)sender {
    [[HXRouter sharedManager]  handleURLString:URLString_ModuleMenu serverNamespace:HXRouterNamespace_RouterDemo];
}
- (IBAction)openPaperList:(id)sender {
    [[HXRouter sharedManager] handleURLString:URLString_PaperList serverNamespace:HXRouterNamespace_RouterDemo];
}
- (IBAction)openPaperDetail:(id)sender {
    [[HXRouter sharedManager] handleURLString:URLString_PaperDetail serverNamespace:HXRouterNamespace_RouterDemo nativeParameters:@{HXRouterIDKey : @(22), HXRouterTitleKey : @"高三语文试卷"}];
}

- (IBAction)openBaidu:(id)sender {
    [[HXRouter sharedManager] handleURLString:@"https://www.baidu.com" serverNamespace:HXRouterNamespace_RouterDemo];
}
- (IBAction)openSina:(id)sender {
    [[HXRouter sharedManager] handleURLString:@"https://www.sina.com.cn" serverNamespace:HXRouterNamespace_RouterDemo];
}
@end
