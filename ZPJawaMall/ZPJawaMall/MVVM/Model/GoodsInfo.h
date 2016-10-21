//
//  GoodsInfo.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsDetail.h"
@interface GoodsInfo : NSObject

@property (nonatomic, strong) GoodsDetail *detail;
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSMutableArray *taimian;
@property (nonatomic, strong) NSMutableArray *door;

@end
