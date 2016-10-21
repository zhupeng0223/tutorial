//
//  ZPOrderDetailInfoViewController.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/28.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "BassViewController.h"
@class GoodsInfo;
@interface ZPOrderDetailInfoViewController : BassViewController

@property (nonatomic, strong) GoodsInfo *goodsInfo;
@property (nonatomic, assign) NSInteger selectedDoorIndex;
@property (nonatomic, assign) NSInteger selectedColorIndex;
@property (nonatomic, assign) NSInteger selectedTaimianIndex;

@end
