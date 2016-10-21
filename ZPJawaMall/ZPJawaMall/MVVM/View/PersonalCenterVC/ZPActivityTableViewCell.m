//
//  ZPActivityTableViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/22.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPActivityTableViewCell.h"
#import "ZPActivity.h"
@interface ZPActivityTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *smallTitleLabel;

@end

@implementation ZPActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)gotoActivityAction:(id)sender {
    
}

- (void)setActivity:(ZPActivity *)activity {
    _activity = activity;
    self.iconImageView.userInteractionEnabled = YES;
    self.iconImageView.layer.cornerRadius = 8;
    self.iconImageView.layer.masksToBounds = YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageBassURL, activity.imgurl]] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
