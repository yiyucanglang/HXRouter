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
    [self testRouterRegistTime];
}

- (void)testRouterRegistTime {
    NSTimeInterval begin, end;
            
    begin = CACurrentMediaTime();

    for (NSInteger i = 0; i < 1000; i++) {
        [[HXRouter sharedManager] registerService:[UIViewController class] URLString:[NSString stringWithFormat:@"parent://paper%@/index", @(i)] serverNamespace:HXRouterNamespace_RouterDemo];
    }
    
    for (NSInteger i = 0; i < 1000; i++) {
        [[HXRouter sharedManager] registerService:[UIViewController class] URLString:[NSString stringWithFormat:@"parent://course%@/submodule", @(i)] serverNamespace:HXRouterNamespace_RouterDemo];
    }
    
    end = CACurrentMediaTime();
    printf("连续注册两千服务耗时:  %.2f ms\n", (end - begin) * 1000);
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
- (IBAction)openCommunityHome:(id)sender {
    [[HXRouter sharedManager] handleURLString:URLString_Community_Home serverNamespace:HXRouterNamespace_Community];
}

- (IBAction)openServiceRedirection:(id)sender {
    [[HXRouter sharedManager] handleURLString:URLString_PaperList serverNamespace:HXRouterNamespace_RouterDemo];
}
@end
