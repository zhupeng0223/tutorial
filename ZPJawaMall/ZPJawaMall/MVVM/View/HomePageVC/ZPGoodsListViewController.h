//
//  ZPGoodsListViewController.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "BassViewController.h"
#import "HomePageGoods.h"

@interface ZPGoodsListViewController : BassViewController

@property (nonatomic, strong) HomePageGoods *goods;
@property (nonatomic, strong) NSArray *dataArray;

@end
