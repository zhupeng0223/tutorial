//
//  ZPHomePageViewModel.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPHomePageViewModel.h"
#import "BannerGoods.h"
#import "GoodsList.h"
#import "GoodsInfo.h"
#import "ZPPicInfo.h"

@implementation ZPHomePageViewModel

- (void)loadBannerInfo {
    AFHTTPSessionManager *manager = [self createAFNetWorking];
    
    NSDictionary *params = @{@"status":@"1"};
    [manager POST:kBannerURL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self handleBannerWithRootDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)handleBannerWithRootDic:(NSDictionary *)dic {
    
    ZPLog(@"%@", dic);
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSArray *tempArr = [dic objectForKey:@"data"];
    for (NSDictionary *dictionary in tempArr) {
        BannerGoods *goods = [[BannerGoods alloc] init];
        [goods setValuesForKeysWithDictionary:dictionary];
        [dataArray addObject:goods];
    }
    
    self.bannerReturnBlock(dataArray);
    
}

- (void)loadNewHomePageInfo {
    
    AFHTTPSessionManager *manager = [self createAFNetWorking];
    NSDictionary *params = @{@"isrecom":@"1"};
    [manager POST:kHomePageURL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handleNewGoodsWithRootDic:dic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)handleNewGoodsWithRootDic:(NSDictionary *)dic {
    ZPLog(@"%@", dic);
    
    NSArray *tempArr = [dic objectForKey:@"data"];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *dictionary in tempArr) {
        HomePageGoods *goods = [[HomePageGoods alloc] init];
        [goods setValuesForKeysWithDictionary:dictionary];
        [dataArray addObject:goods];
    }
    
    self.homePageGoodsReturnBlock(dataArray);
    
}

- (AFHTTPSessionManager *)createAFNetWorking {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    return manager;
}

- (void)getGoodsListWithGoods:(HomePageGoods *)goods {
    AFHTTPSessionManager *manager = [self createAFNetWorking];
    NSDictionary *params = @{@"isrecom":@"-1", @"key":goods.goodsname};
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
    for (NSDictionary *dictionary in tempArr) {
        GoodsList *goodsList = [[GoodsList alloc] init];
        [goodsList setValuesForKeysWithDictionary:dictionary];
        [resultArr addObject:goodsList];
    }
    self.returnBlock(resultArr);
}

- (void)getGoodsDetailWithGoodsId:(NSString *)ID {
    AFHTTPSessionManager *manager = [self createAFNetWorking];
    NSDictionary *parems = @{@"gid":ID};
    [manager POST:kGoodsDetailURL parameters:parems progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handleGoodsDetailWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)handleGoodsDetailWithDic:(NSDictionary *)dic {
    
    NSDictionary *tempDic = dic[@"data"];
    GoodsInfo *goodsInfo = [[GoodsInfo alloc] init];
    [goodsInfo setValuesForKeysWithDictionary:tempDic];
    
    self.returnBlock(goodsInfo);
    
}

- (void)loadHotHomePageInfo {
    AFHTTPSessionManager *manager = [self createAFNetWorking];
    NSDictionary *params = @{@"isrecom":@"2"};
    [manager POST:kHomePageURL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handleHotGoodsWithRootDic:dic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)handleHotGoodsWithRootDic:(NSDictionary *)dic {
    ZPLog(@"%@", dic);
    
    NSArray *tempArr = [dic objectForKey:@"data"];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *dictionary in tempArr) {
        HomePageGoods *goods = [[HomePageGoods alloc] init];
        [goods setValuesForKeysWithDictionary:dictionary];
        [dataArray addObject:goods];
    }
    
    self.hotHomePageGoodsReturnBlock(dataArray);
    
}

- (void)getPicSizeWithGoodsId:(NSString *)ID {
    
    AFHTTPSessionManager *manager = [self createAFNetWorking];
    
    NSDictionary *param = @{@"gid":ID};
    [manager POST:kGetPicSize parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        NSArray *rootArr = rootDic[@"data"];
        NSMutableArray *result = [NSMutableArray array];
        for (NSDictionary *dic in rootArr) {
            ZPPicInfo *picInfo = [[ZPPicInfo alloc] init];
            [picInfo setValuesForKeysWithDictionary:dic];
            [result addObject:picInfo];
        }
        self.returnBlock(result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
