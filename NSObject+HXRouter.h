//
//  NSObject+HXRouter.h
//  JamesCreative
//
//  Created by James on 2020/1/20.
//  Copyright © 2020 James. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXRouterRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HXRouter)
@property (nonatomic, strong) HXRouterRequest  *routeRequest;
@end

NS_ASSUME_NONNULL_END
