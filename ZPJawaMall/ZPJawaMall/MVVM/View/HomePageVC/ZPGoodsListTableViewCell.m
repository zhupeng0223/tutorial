//
//  ZPGoodsListTableViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPGoodsListTableViewCell.h"

@interface ZPGoodsListTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *reservationCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;

@end

@implementation ZPGoodsListTableViewCell

- (void)dealloc {
    ZPLog(@"%@  dealloc",self);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoodsList:(GoodsList *)goodsList {
    _goodsList = goodsList;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageBassURL, [goodsList.picurl componentsSeparatedByString:@";"][0]]] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
    self.nameLabel.text = goodsList.goodsname;
    self.reservationCountLabel.text = [NSString stringWithFormat:@"%ld", (long)goodsList.myordercount];
    self.commentsLabel.text = [NSString stringWithFormat:@"%ld人评价", (long)goodsList.mycommentcount];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
