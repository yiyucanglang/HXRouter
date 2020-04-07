//
//  CommunityHomeViewController.m
//  HXRouterDemo
//
//  Created by James on 2020/4/2.
//  Copyright © 2020 James. All rights reserved.
//

#import "CommunityHomeViewController.h"

#import "CommunityModuleHeader.h"

HXMacroReigisterService(CommunityHomeViewController, URLString_Community_Home, HXRouterNamespace_Community)
@interface CommunityHomeViewController ()

@end

@implementation CommunityHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CommunityHomeViewController";
    self.view.backgroundColor = [UIColor yellowColor];
}

@end
