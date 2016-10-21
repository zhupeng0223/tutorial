//
//  ZPClassTitleCollectionViewCell.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/19.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPClassTitleCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rightIconImageView;

@property (strong, nonatomic) IBOutlet UIView *classView;
@property (strong, nonatomic) IBOutlet UIView *classRedView;
@property (strong, nonatomic) IBOutlet UILabel *classNameLabel;

- (void)setClassviewHidden:(BOOL)hidden;
- (void)setClassTitleViewHidden:(BOOL)hidden;

@end
