//
//  XXNetWorkUtils.h
//  AFNetworking
//
//  Created by R on 2018/7/21.
//

#import <Foundation/Foundation.h>

@interface XXNetWorkUtils : NSObject

+ (void)showNetworkStatus:(void(^)(NSInteger))block; ///监听网络状态 推荐使用xx_showNetworkStatus
+ (void)xx_showNetworkStatus:(void(^)(NSInteger))block; ///监听网络状态

@end
