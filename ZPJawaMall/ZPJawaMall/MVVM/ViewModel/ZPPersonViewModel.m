//
//  ZPPersonViewModel.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/22.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPPersonViewModel.h"
#import "Order.h"
#import "ZPActivity.h"
#import "ZPAddress.h"

@implementation ZPPersonViewModel

- (void)getUserOrderWithUID:(NSString *)uid {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *param = @{@"uid":uid};
    
    [manager POST:kGetUserOrderURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:&error];
        [self handelWithUserOrderWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)handelWithUserOrderWithDic:(NSDictionary *)dic {
    
    if (![dic[@"data"] isEqualToString:@""]) {
        NSArray *tempArr = dic[@"data"];
        NSMutableArray *result = [NSMutableArray array];
            
        for (NSDictionary *dictionary in tempArr) {
            Order *order = [[Order alloc] init];
            [order setValuesForKeysWithDictionary:dictionary];
            [result addObject:order];
        }
        self.returnBlock(result);
    }
}

- (void)getActivityInfo {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *param = @{@"action":@"activity"};
    [manager POST:kGetActivityURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:&error];
        [self handelActivityWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)handelActivityWithDic:(NSDictionary *)dic {
    
    NSArray *tempArr = dic[@"data"];
    NSMutableArray *newResultArr = [NSMutableArray array];
    NSMutableArray *oldResultArr = [NSMutableArray array];
    for (NSDictionary *dictionary in tempArr) {
        ZPActivity *activity = [[ZPActivity alloc] init];
        [activity setValuesForKeysWithDictionary:dictionary];
        if ([activity.status isEqualToString:@"0"]) {
            //往期
            [oldResultArr addObject:activity];
        }else if ([activity.status isEqualToString:@"1"]) {
            //现在
            [newResultArr addObject:activity];
        }
    }
    NSDictionary *result = @{@"new": newResultArr, @"old": oldResultArr};
    
    self.returnBlock(result);
    
}

- (void)getAddress:(NSString *)uid {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *param = @{@"uid":uid};
    [manager POST:kGetAddressUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handleAddressWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)handleAddressWithDic:(NSDictionary *)dic {
    if ([dic[@"info"] isEqualToString:@"success"]) {
        NSArray *tempArray = dic[@"data"];
        NSMutableArray *result = [NSMutableArray array];
        for (NSDictionary *dictionary in tempArray) {
            ZPAddress *address = [[ZPAddress alloc] init];
            [address setValuesForKeysWithDictionary:dictionary];
            [result addObject:address];
        }
        self.returnBlock(result);
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"info"] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:action];
    }
}

- (void)editNewAddressWithInfo:(NSDictionary *)info {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    ZPLog(@"%@", info);
    [manager POST:kEditAddressURL parameters:info progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        self.returnBlock(rootDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end







