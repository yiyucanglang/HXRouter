//
//  CommunityListViewController.m
//  HXRouterDemo
//
//  Created by James on 2020/4/2.
//  Copyright © 2020 James. All rights reserved.
//

#import "CommunityListViewController.h"

#import "CommunityModuleHeader.h"

HXMacroReigisterService(CommunityListViewController, URLString_Community_List, HXRouterNamespace_Community)

@interface CommunityListViewController ()

@end

@implementation CommunityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CommunityListViewController";
    self.view.backgroundColor = [UIColor blackColor];
}

@end
