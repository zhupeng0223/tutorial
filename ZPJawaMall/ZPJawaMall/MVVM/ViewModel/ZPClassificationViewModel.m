//
//  ZPClassificationViewModel.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/1.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPClassificationViewModel.h"

@implementation ZPClassificationViewModel

- (void)loadClassificationInfo {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *param = @{@"action":@"class"};
    [manager POST:kGetClassURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       //
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self handleWithDic:rootDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)handleWithDic:(NSDictionary *)dic {
    ZPLog(@"%@", dic);
    //数据处理
    
    NSArray *tempArr = dic[@"data"];
//    if ((int)dic[@"code"] == 200) {
        self.classificationReturnBlock(tempArr);
//    }
    
}

@end
