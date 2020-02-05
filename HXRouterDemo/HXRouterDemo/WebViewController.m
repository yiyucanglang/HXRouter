//
//  WebViewController.m
//  HXRouterDemo
//
//  Created by 周义进 on 2020/2/6.
//  Copyright © 2020 James. All rights reserved.
//

#import "WebViewController.h"
#import "HXRouteDemoServiceHeader.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
HXMacroReigisterService(WebViewController, HXRouteWebServiceURLString, HXRouterNamespace_RouterDemo)

@interface WebViewController ()
@property (nonatomic, strong) WKWebView *webview;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSURL *url = [NSURL URLWithString:self.routeRequest.URLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webview loadRequest:request];
}

- (WKWebView *)webview {
    if (!_webview) {
        _webview = [[WKWebView alloc] initWithFrame:CGRectZero];
    }
    return _webview;
}

@end
