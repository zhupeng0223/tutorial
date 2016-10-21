//
//  ZPTopIconInfoTableViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/1.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPTopIconInfoTableViewCell.h"

@interface ZPTopIconInfoTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *bacImageView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageVIew;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;


@end

@implementation ZPTopIconInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.frame = CGRectMake(0, 0, kScreenWidth, 180);
    self.iconImageVIew.layer.cornerRadius = 30;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;
    
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:userInfo.headImg] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
    self.userNameLabel.text = userInfo.nickname;
    self.phoneNumberLabel.text = userInfo.phone;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
}

@end
