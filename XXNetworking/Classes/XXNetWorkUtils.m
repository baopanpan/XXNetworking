//
//  XXNetWorkUtils.m
//  AFNetworking
//
//  Created by R on 2018/7/21.
//

#import "XXNetWorkUtils.h"
#import "AFNetworkReachabilityManager.h"

@implementation XXNetWorkUtils

+ (void)showNetworkStatus:(void (^)(NSInteger))block {
    [self xx_showNetworkStatus:block];
}

+ (void)xx_showNetworkStatus:(void (^)(NSInteger))block {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 提示：要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    //检测的结果
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        block(status);
    }];
}

@end
