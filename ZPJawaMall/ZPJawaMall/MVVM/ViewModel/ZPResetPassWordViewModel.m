//
//  ZPResetPassWordViewModel.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPResetPassWordViewModel.h"

@implementation ZPResetPassWordViewModel

- (void)getVerificationCodeWithPhoneNumber:(NSString *)phone {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:kRetrievePasswordVerCode parameters:@{@"phoneNum": phone} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        self.returnBlock(rootDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)resetPassWord {
    
}

@end
