//
//  HXRouteDemoServiceHeader.h
//  HXRouterDemo
//
//  Created by James on 2020/1/22.
//  Copyright © 2020 James. All rights reserved.
//

#ifndef HXRouteDemoServiceHeader_h
#define HXRouteDemoServiceHeader_h

#import "HXRouter.h"

#pragma mark -ModuleA
static NSString *URLString_ModuleA = @"routerdemo://moduleA";
static NSString *ModuleA_StudentIDKey = @"id";
static NSString *ModuleA_StudentNameKey  = @"name";
//required: id
//optional: name
// parameters sample {@"id" : @(90), @"name" : @"张三"};


#pragma mark -ModuleB
static NSString *URLString_ModuleB = @"routerdemo://moduleB";


#pragma mark -ModuleMenu
static NSString *URLString_ModuleMenu = @"routerdemo://moduleMenu";


#pragma mark -ModuleFavourite
static NSString *URLString_ModuleFavourite = @"routerdemo://moduleFavourite";

#pragma mark -ModuleFan
static NSString *URLString_ModuleFan = @"routerdemo://moduleFan";
//required: title
// parameters sample {@"title" : @"我的粉丝圈"}

#pragma mark -ModuleLogin
static NSString *URLString_ModuleLogin = @"routerdemo://moduleLogin";

#pragma mark -PaperList
static NSString *URLString_PaperList = @"routerdemo://paper/subservice/list";


#pragma mark -PaperDetail
static NSString *URLString_PaperDetail = @"routerdemo://paper/subservice/detail";
//required: id, title
// parameters sample {@"id" : @(90), @"title" : @"高三语文试卷"}

#endif /* HXRouteDemoServiceHeader_h */
