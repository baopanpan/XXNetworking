//
//  NSObject+HTTP.m
//  ChatTest
//
//  Created by R on 2018/7/9.
//  Copyright © 2018年 baopanpan. All rights reserved.
//

#import "NSObject+HTTP.h"
#import <objc/runtime.h>

@implementation NSObject (HTTP)


- (AFHTTPSessionManager *)manager {
    return objc_getAssociatedObject(self, @"AFHTTPSessionManager");
}

- (void)setManager:(AFHTTPSessionManager *)manager {
    objc_setAssociatedObject(self, @"AFHTTPSessionManager", manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AFHTTPSessionManager *)httpSessionManager {
    if (self.manager == nil) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
        self.manager = manager;
    }
    return self.manager;
}

- (void)POSTRequestWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSLog(@"%p",[self httpSessionManager]);
    [[self httpSessionManager] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
   
}

- (void)GETRequestWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSLog(@"%p",[self httpSessionManager]);
    [[self httpSessionManager] GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)downLoadWithUrl:(NSString *)url downloadPath:(NSString *)path downloadProgress:(void (^)(CGFloat))download complete:(void (^)(BOOL,id))complete {
    
    NSURLSessionDownloadTask *task = [[self httpSessionManager] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat progress = 1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
        
        if (download) {
            download(progress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载地址
        if (path) {
           return [NSURL fileURLWithPath:path];
        }
        return targetPath;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error == nil) {
            complete(YES,filePath);
        } else {
            complete(NO,filePath);
        }
    }];
    [task resume];
    
}

- (void)uploadFile:(NSString *)url params:(NSDictionary *)params fileURL:(NSURL *)fileURL uploadProgress:(void(^)(CGFloat))upload success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [self uploadFile:url params:params fileURL:fileURL imageArray:nil uploadProgress:upload success:success failure:failure];
}

- (void)uploadImage:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image uploadProgress:(void (^)(CGFloat))upload success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [self uploadFile:url params:params fileURL:nil imageArray:@[image] uploadProgress:upload success:success failure:failure];
}

- (void)uploadImages:(NSString *)url params:(NSDictionary *)params imageArray:(NSArray *)imageArray uploadProgress:(void (^)(CGFloat))upload success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [self uploadFile:url params:params fileURL:nil imageArray:imageArray uploadProgress:upload success:success failure:failure];
}

- (void)uploadFile:(NSString *)url params:(NSDictionary *)params fileURL:(NSURL *)fileURL imageArray:(NSArray *)imageArray uploadProgress:(void(^)(CGFloat))upload success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    [[self httpSessionManager] POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (fileURL) {
            [formData appendPartWithFileURL:fileURL name:@"file" error:nil];
        } else {
            for (UIImage *image in imageArray) {
                long long time = [[NSDate date] timeIntervalSince1970];
                NSString *imageName = [NSString stringWithFormat:@"%lld",time];
                NSData *imageData = UIImagePNGRepresentation(image);
                [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/png"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        NSLog(@"上传进度:%f",progress);
        upload(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
