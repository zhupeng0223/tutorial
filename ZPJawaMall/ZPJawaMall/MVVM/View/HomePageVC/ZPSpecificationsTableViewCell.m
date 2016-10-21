//
//  ZPSpecificationsTableViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/12.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPSpecificationsTableViewCell.h"

@interface ZPSpecificationsTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *specificationsLabel;

@end

@implementation ZPSpecificationsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSpecifications:(NSString *)specifications {
    _specifications = specifications;
    
    self.specificationsLabel.text = self.specifications;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
