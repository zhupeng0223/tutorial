//
//  HomeGoodsCollectionViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/30.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "HomeGoodsCollectionViewCell.h"

@interface HomeGoodsCollectionViewCell ()

@property (strong, nonatomic) UIView *bacView;
@property (strong, nonatomic) UIImageView *goodsImageView;
@property (strong, nonatomic) UILabel *isrecomLabel;
@property (strong, nonatomic) UILabel *goodsTitleLabel;
@property (strong, nonatomic) UILabel *currentPrice;
@property (strong, nonatomic) UILabel *olderPrice;

@end

@implementation HomeGoodsCollectionViewCell
- (void)dealloc {
    ZPLog(@"%@  dealloc",self);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bacView = [[UIView alloc] init];
        [self.contentView addSubview:self.bacView];
        
        self.goodsImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.bacView addSubview:self.goodsImageView];
        
        self.isrecomLabel = [[UILabel alloc] init];
        [self.bacView addSubview:self.isrecomLabel];
        
        self.goodsTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.goodsTitleLabel];
        
        self.currentPrice = [[UILabel alloc] init];
        [self.contentView addSubview:self.currentPrice];
        
        self.olderPrice = [[UILabel alloc] init];
        [self.contentView addSubview:self.olderPrice];
        
    }
    return self;
}


- (void)setGoods:(HomePageGoods *)goods {
    _goods = goods;
    
    if ([goods.status isEqualToString:@"1"]) {
        self.isrecomLabel.text = @"新品";
    }else if ([goods.status isEqualToString:@"2"]) {
        self.isrecomLabel.text = @"热门";
    }
    
    NSString *imageURLString = [[goods.picurl componentsSeparatedByString:@";"] lastObject];
    ZPLog(@"imageUrl = %@", [NSString stringWithFormat:@"%@%@", kImageBassURL, goods.picurl]);
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageBassURL, imageURLString]] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
    
    self.goodsTitleLabel.text = goods.goodsname;
    self.currentPrice.text = goods.price;
    
    self.olderPrice.text = goods.price_old;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, (kScreenWidth - 30) / 2, kScreenWidth / 2);
    
    self.bacView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.bacView.backgroundColor = [UIColor whiteColor];
    self.bacView.layer.masksToBounds = YES;
    self.bacView.layer.cornerRadius = 8;
    
    self.isrecomLabel.frame = CGRectMake(self.bounds.size.width - 45, 5, 40, 20);
    self.isrecomLabel.backgroundColor = [UIColor redColor];
    self.isrecomLabel.alpha = 0.8;
    self.isrecomLabel.layer.masksToBounds = YES;
    self.isrecomLabel.layer.cornerRadius = 3;
    self.isrecomLabel.textColor = [UIColor whiteColor];
    self.isrecomLabel.textAlignment = NSTextAlignmentCenter;
    self.isrecomLabel.font = [UIFont systemFontOfSize:16];
    
    self.goodsImageView.frame = CGRectMake(0, 0, self.bounds.size.width, ((kScreenWidth - 20) / 2 - 5) * 2 / 3);
    
    self.goodsTitleLabel.frame = CGRectMake(8, self.goodsImageView.bounds.size.height + 5, self.bounds.size.width - 16, 20);
    self.goodsTitleLabel.textColor = kGoodsTitleColor;
    self.goodsTitleLabel.font = [UIFont systemFontOfSize:13];
    
    self.currentPrice.frame = CGRectMake(8, self.goodsTitleLabel.frame.origin.y + 25, self.goodsTitleLabel.bounds.size.width, self.goodsTitleLabel.bounds.size.height);
    self.currentPrice.textColor = [UIColor redColor];
    self.currentPrice.font = [UIFont systemFontOfSize:12];
    self.currentPrice.text = [self priceStringProcessingWithFirstPriceString:_goods.price lastPriceString:_goods.price1 older:NO];
    
    self.olderPrice.frame = CGRectMake(8, self.currentPrice.frame.origin.y + 25, self.currentPrice.bounds.size.width, self.currentPrice.bounds.size.height);
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[self priceStringProcessingWithFirstPriceString:_goods.price_old lastPriceString:_goods.price_old1 older:YES] attributes:attribtDic];
    self.olderPrice.attributedText = attribtStr;
    self.olderPrice.textColor = kOldPriceColor;
    self.olderPrice.font = [UIFont systemFontOfSize:12];
    
    self.bacView.layer.masksToBounds = YES;
    self.bacView.layer.cornerRadius = 10;
    
    self.isrecomLabel.layer.masksToBounds = YES;
    self.isrecomLabel.layer.cornerRadius = 5;
    
}

- (NSString *)priceStringProcessingWithFirstPriceString:(NSString *)firstStr lastPriceString:(NSString *)lastStr older:(BOOL)isOlder{
    
    NSString *string1 = nil;
    NSString *string2 = nil;
    string1 = [NSString stringWithFormat:@"现价: ￥%@-%@", firstStr, lastStr];
    string2 = [NSString stringWithFormat:@"原价: ￥%@-%@", firstStr, lastStr];
    if ([firstStr isEqualToString:@"0"] || [lastStr isEqualToString:@"0"]) {
        string1 = [NSString stringWithFormat:@"现价: ￥%@", firstStr];
        string2 = [NSString stringWithFormat:@"原价: ￥%@", firstStr];
    }
    
    if (isOlder) {
        return string2;
    }else {
        return string1;
    }
}

@end
