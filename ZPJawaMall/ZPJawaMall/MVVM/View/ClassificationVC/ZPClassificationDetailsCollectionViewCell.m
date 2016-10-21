//
//  ZPClassificationDetailsCollectionViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/20.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPClassificationDetailsCollectionViewCell.h"
#import "GoodsList.h"

@interface ZPClassificationDetailsCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentPriceLabel;

@end

@implementation ZPClassificationDetailsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoodsList:(GoodsList *)goodsList {
    _goodsList = goodsList;
    
    ZPLog(@"%@", [NSString stringWithFormat:@"%@%@", kImageBassURL, goodsList.picurl]);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[[NSString stringWithFormat:@"%@%@", kImageBassURL, goodsList.picurl] componentsSeparatedByString:@";"] firstObject]] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
    self.titleLabel.text = goodsList.goodsname;
    self.currentPriceLabel.text = [NSString stringWithFormat:@"现价:￥%@-￥%@", goodsList.price, goodsList.price1];
    
}

@end
