//
//  ZPStoreInfoViewModel.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/28.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPStoreInfoViewModel.h"
#import "ZPStores.h"
#import "ZPEmployees.h"

@implementation ZPStoreInfoViewModel

- (void)getStoresInfoWithCity:(NSString *)city {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *param = @{@"cityName":city, @"action":@"store"};
    
    [manager POST:kGetStoresURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handelWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)handelWithDic:(NSDictionary *)dic {
    if ([dic[@"code"] isEqualToString:@"200"]) {
        NSArray *tempArray = dic[@"data"];
        NSMutableArray *result = [NSMutableArray array];
        for (NSDictionary *dictionary in tempArray) {
            ZPStores *store = [[ZPStores alloc] init];
            [store setValuesForKeysWithDictionary:dictionary];
            [result addObject:store];
        }
        self.returnBlock(result);
    }
}

- (void)getEmployeesWithStoreName:(NSString *)name {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *param = @{@"storeName":name, @"action":@"staff"};
    
    [manager POST:kGetStoreInfoURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handelEmployeesWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)handelEmployeesWithDic:(NSDictionary *)dic {
    if ([dic[@"code"] isEqualToString:@"200"]) {
        NSArray *tempArray = dic[@"data"];
        NSMutableArray *result = [NSMutableArray array];
        for (NSDictionary *dictionary in tempArray) {
            ZPEmployees *employe = [[ZPEmployees alloc] init];
            [employe setValuesForKeysWithDictionary:dictionary];
            [result addObject:employe];
        }
        self.returnBlock(result);
    }
}

@end










