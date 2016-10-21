//
//  ZPShoppingCartViewModel.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/10/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPShoppingCartViewModel.h"
#import "ZPShoppingCart.h"
#import "ZPOrderInfo.h"
#import "ZPGeneratePartsOrder.h"

@implementation ZPShoppingCartViewModel

- (void)addShoppingCartWithParam:(NSDictionary *)param {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:kAddShoppingCart parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        self.returnBlock(rootDic[@"info"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)getShoppingCarWithUID:(NSString *)uid {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *param = @{@"uid":uid};
    [manager POST:kGetShoppingCart parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handelWithRootDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)handelWithRootDic:(NSDictionary *)dic {
    if ([dic[@"info"] isEqualToString:@"success"]) {
        NSMutableArray *result = [NSMutableArray array];
        NSArray *tempArr = dic[@"data"];
        for (NSDictionary *dictionary in tempArr) {
            ZPShoppingCart *shoppingCart = [[ZPShoppingCart alloc] init];
            [shoppingCart setValuesForKeysWithDictionary:dictionary];
            [result addObject:shoppingCart];
        }
        self.returnBlock(result);
    }
}

- (void)checkShoppingCartWithParam:(NSDictionary *)param {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:kGenerateMainOrder parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handelOrderWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)handelOrderWithDic:(NSDictionary *)dic {
    
    if ([dic[@"info"] isEqualToString:@"success"]) {
        NSDictionary *data = dic[@"data"];
        ZPOrderInfo *orderInfo = [[ZPOrderInfo alloc] init];
        [orderInfo setValuesForKeysWithDictionary:data];
        self.returnBlock(orderInfo);
    }
    
}

- (void)checkShoppingCartProductsWithParam:(NSDictionary *)param {
    //提交配件支付
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:kGeneratePartsOrder parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handelGeneratePartsWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)handelGeneratePartsWithDic:(NSDictionary *)dic {
    if ([dic[@"info"] isEqualToString:@"success"]) {
        
        ZPGeneratePartsOrder *partsOrder = [[ZPGeneratePartsOrder alloc] init];
        [partsOrder setValuesForKeysWithDictionary:dic[@"data"]];
        self.returnBlock(partsOrder);
        
    }
}

- (void)checkShoppingCartGenerateHomeOrderWithParam:(NSDictionary *)param {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:kGenerateHomeOrder parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handelGeneratePartsWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end


