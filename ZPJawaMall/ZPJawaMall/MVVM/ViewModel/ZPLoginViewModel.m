//
//  ZPLoginViewModel.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/1.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPLoginViewModel.h"
#import "UserInfo.h"

@interface ZPLoginViewModel ()

@property (nonatomic, copy) NSString *currentUserName;
@property (nonatomic, copy) NSString *currentPassWord;

@end

@implementation ZPLoginViewModel

- (void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord {
    self.currentUserName = userName;
    self.currentPassWord = passWord;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSDictionary *param = @{@"username": self.currentUserName, @"password": self.currentPassWord};
    [manager POST:kLoginURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error = nil;
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:&error];
        ZPLog(@"%@", error);
        [self handleWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)handleWithDic:(NSDictionary *)dic {
    
    
    //解析数据并返回结果给returnBlock
    UserInfo *userInfo = [[UserInfo alloc] init];
    if ([dic[@"code"] isEqualToString:@"200"]) {
        NSDictionary *tempDic = [dic objectForKey:@"data"];
        [userInfo setValuesForKeysWithDictionary:tempDic];
        self.loginReturnBlock(userInfo);
    }else if ([dic[@"code"] isEqualToString:@"400"]) {
        self.loginErrorBlock(userInfo);
    }
}

@end
