//
//  ZPPriceDetailTableViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/12.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPPriceDetailTableViewCell.h"
#include "GoodsDetail.h"

@interface ZPPriceDetailTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *appointmentPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *appointmentCountLabel;

@end

@implementation ZPPriceDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoodsDetail:(GoodsDetail *)goodsDetail {
    _goodsDetail = goodsDetail;
    
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@-%@", goodsDetail.price, goodsDetail.price1];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价:￥%@-%@", goodsDetail.price_old, goodsDetail.price_old1] attributes:attribtDic];
    self.oldPriceLabel.attributedText = attribtStr;
    self.appointmentPriceLabel.text = [NSString stringWithFormat:@"预约金:￥%ld", (long)goodsDetail.ordermoney];
    self.appointmentCountLabel.text = [NSString stringWithFormat:@"%ld人预约", (long)goodsDetail.ordercount];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
