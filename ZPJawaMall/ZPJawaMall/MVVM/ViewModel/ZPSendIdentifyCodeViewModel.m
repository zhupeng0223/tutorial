//
//  ZPSendIdentifyCodeViewModel.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/2.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPSendIdentifyCodeViewModel.h"

@implementation ZPSendIdentifyCodeViewModel

- (void)sendIdentifyCodeWithPhoneNumber:(NSString *)phone {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *param = @{@"phoneNum": phone};
    
    [manager POST:kVerificationCode parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        self.sendIdentifyCodeReturnBlock(rootDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
