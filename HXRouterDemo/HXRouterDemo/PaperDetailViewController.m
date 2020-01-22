//
//  PaperDetailViewController.m
//  HXRouterDemo
//
//  Created by James on 2020/1/22.
//  Copyright © 2020 James. All rights reserved.
//

#import "PaperDetailViewController.h"

#import "HXRouterHandler.h"

@interface PaperDetailViewController ()

@end



@implementation PaperDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.routeRequest.parameters[HXRouterTitleKey];
    self.view.backgroundColor = [UIColor purpleColor];
}


@end
