//
//  ZPClassificationDetailsViewModel.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/20.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPClassificationDetailsViewModel.h"
#import "GoodsList.h"
#import "GoodsInfo.h"

@implementation ZPClassificationDetailsViewModel

- (void)getClassificationListDetailsWithName:(NSString *)name {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *params = @{@"isrecom":@"-1", @"key":name};
    [manager POST:kGoodsListURL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handleGoodsListWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)handleGoodsListWithDic:(NSDictionary *)dic {
    NSArray *tempArr = dic[@"data"];
    NSMutableArray *resultArr = [NSMutableArray array];
    if (![tempArr isEqual:@""]) {
        for (NSDictionary *dictionary in tempArr) {
            GoodsList *goodsList = [[GoodsList alloc] init];
            [goodsList setValuesForKeysWithDictionary:dictionary];
            [resultArr addObject:goodsList];
        }
        self.returnBlock(resultArr);
    }
}

- (void)getClassificationListDetailsWithId:(NSString *)ID {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *parems = @{@"gid": ID};
    [manager POST:kGoodsDetailURL parameters:parems progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handleGoodsDetailWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)handleGoodsDetailWithDic:(NSDictionary *)dic {
    if (![dic[@"info"] isEqualToString:@"error"]) {
        
        NSDictionary *tempDic = dic[@"data"];
        GoodsInfo *goodsInfo = [[GoodsInfo alloc] init];
        [goodsInfo setValuesForKeysWithDictionary:tempDic];
        
        self.classificationReturnBlock(goodsInfo);
    }
    
}

@end
