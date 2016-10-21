//
//  ZPAddressDetailInfoTableViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/26.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPAddressDetailInfoTableViewCell.h"
#import "ZPAddress.h"
@interface ZPAddressDetailInfoTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *addressInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@end

@implementation ZPAddressDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddress:(ZPAddress *)address {
    _address = address;
    
    self.addressInfoLabel.text = address.address;
    self.userNameLabel.text = address.receivername;
    self.phoneNumberLabel.text = address.phone;
    
}

@end
