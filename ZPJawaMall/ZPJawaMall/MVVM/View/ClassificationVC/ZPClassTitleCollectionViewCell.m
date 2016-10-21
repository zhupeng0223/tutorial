//
//  ZPClassTitleCollectionViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/19.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPClassTitleCollectionViewCell.h"

@implementation ZPClassTitleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setClassviewHidden:(BOOL)hidden {
    self.classView.hidden = hidden;
    self.classRedView.hidden = hidden;
    self.classNameLabel.hidden = hidden;
}

- (void)setClassTitleViewHidden:(BOOL)hidden {
    self.titleLabel.hidden = hidden;
    self.rightIconImageView.hidden = hidden;
}

@end
