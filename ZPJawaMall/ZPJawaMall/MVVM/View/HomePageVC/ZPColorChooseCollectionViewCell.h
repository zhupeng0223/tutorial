//
//  ZPColorChooseCollectionViewCell.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/12.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Color;
@class Taimian;
@class Door;
@interface ZPColorChooseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Color *color;
@property (nonatomic, strong) Taimian *taimian;
@property (nonatomic, strong) Door *door;
@property (strong, nonatomic) IBOutlet UIView *backGroundView;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)clearBorderColor;
- (void)setRedBorderColor;

@end
