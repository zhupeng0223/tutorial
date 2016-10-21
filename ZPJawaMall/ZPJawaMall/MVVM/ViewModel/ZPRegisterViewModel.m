//
//  ZPRegisterViewModel.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/2.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPRegisterViewModel.h"

@implementation ZPRegisterViewModel

- (void)registerWithInfo:(NSDictionary *)info {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:kRegisterURL parameters:info progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        self.returnBlock(rootDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
