//
//  ZPColorChooseCollectionViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/12.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPColorChooseCollectionViewCell.h"
#import "Color.h"
#import "Taimian.h"
#import "Door.h"

@interface ZPColorChooseCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ZPColorChooseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.backGroundView.layer.borderWidth = 1;
//    self.backGroundView.layer.borderColor = [[UIColor redColor] CGColor];
    
}

- (void)clearBorderColor {
    self.backGroundView.layer.borderColor = [[UIColor clearColor] CGColor];
}
- (void)setRedBorderColor {
    self.backGroundView.layer.borderColor = [[UIColor redColor] CGColor];
}

- (void)setColor:(Color *)color {
    _color = color;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageBassURL, color.cpath]] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
}

- (void)setTaimian:(Taimian *)taimian {
    _taimian = taimian;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageBassURL, taimian.tpath]] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
}

- (void)setDoor:(Door *)door {
    _door = door;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageBassURL, door.dpath]] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
}

@end
