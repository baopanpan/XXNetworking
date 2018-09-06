//
//  NSObject+HTTP.h
//  ChatTest
//
//  Created by R on 2018/7/9.
//  Copyright © 2018年 baopanpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NSObject (HTTP)

@property (nonatomic,strong) AFHTTPSessionManager *manager;

/**POST请求*/
- (void)POSTRequestWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/**GET请求*/
- (void)GETRequestWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/**下载*/
- (void)downLoadWithUrl:(NSString *)url downloadPath:(NSString *)path downloadProgress:(void (^)(CGFloat))download complete:(void (^)(BOOL,id))complete;
/**上传文件*/
- (void)uploadFile:(NSString *)url params:(NSDictionary *)params fileURL:(NSURL *)fileURL uploadProgress:(void(^)(CGFloat))upload success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/**上传单张图片*/
- (void)uploadImage:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image uploadProgress:(void(^)(CGFloat))upload success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/**上传多张图片*/
- (void)uploadImages:(NSString *)url params:(NSDictionary *)params imageArray:(NSArray *)imageArray uploadProgress:(void(^)(CGFloat))upload success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
