//
//  HomeGoodsTableViewCell.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/30.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageGoods.h"

@interface HomeGoodsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentSection;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
