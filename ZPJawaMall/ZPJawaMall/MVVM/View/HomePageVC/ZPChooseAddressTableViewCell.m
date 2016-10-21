//
//  ZPChooseAddressTableViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPChooseAddressTableViewCell.h"
#import "ZPAddress.h"

@interface ZPChooseAddressTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *chooseTagImageView;

@end

@implementation ZPChooseAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAddress:(ZPAddress *)address {
    _address = address;
    
//    self.isSelected = [[NSUserDefaults standardUserDefaults] boolForKey:@"isSelectedAddress"];
    self.nameLabel.text = address.receivername;
    [self.nameLabel sizeToFit];
    self.phoneLabel.text = address.phone;
    self.addressLabel.text = address.address;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isSelected) {
        self.chooseTagImageView.hidden = NO;
    }else {
        self.chooseTagImageView.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
