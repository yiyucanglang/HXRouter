//
//  HXRouterHandler.h
//  JamesCreative
//
//  Created by James on 2020/1/15.
//  Copyright © 2020 James. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXRouterUtility.h"
#import "HXRouterRequest.h"
#import "NSObject+HXRouter.h"

NS_ASSUME_NONNULL_BEGIN

/// An object to handle the specific business loigc when route matcing successfully
@interface HXRouterHandler : NSObject

- (BOOL)shouldHandleWithRequest:(HXRouterRequest *)request error:(NSError **)error;

-(id)serviceWithRequest:(HXRouterRequest *)request;

-(id)clientWithRequest:(HXRouterRequest *)request;

-(void)handleRequest:(HXRouterRequest *)request;

@end

NS_ASSUME_NONNULL_END
