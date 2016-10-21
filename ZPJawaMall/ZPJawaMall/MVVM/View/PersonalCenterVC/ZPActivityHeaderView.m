//
//  ZPActivityHeaderView.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/22.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPActivityHeaderView.h"

@interface ZPActivityHeaderView ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *leftView;


@end

@implementation ZPActivityHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZPActivityHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)setRed {
    self.titleLabel.textColor = [UIColor redColor];
    self.leftView.backgroundColor = [UIColor redColor];
}

- (void)setGray {
    self.titleLabel.textColor = kLightGrayColor;
    self.leftView.backgroundColor = kLightGrayColor;
}

@end
