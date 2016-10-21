//
//  ZPHomePageViewModel.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ViewModelClass.h"
#import "HomePageGoods.h"

@interface ZPHomePageViewModel : ViewModelClass

- (void)loadBannerInfo;
- (void)loadNewHomePageInfo;
- (void)loadHotHomePageInfo;

- (void)getGoodsListWithGoods:(HomePageGoods *)goods;
- (void)getGoodsDetailWithGoodsId:(NSString *)ID;
- (void)getPicSizeWithGoodsId:(NSString *)ID;

@end
