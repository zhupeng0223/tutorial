//
//  ZPHomePageGoodsHeadView.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/31.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPHomePageGoodsHeadView.h"

@interface ZPHomePageGoodsHeadView ()

@property (strong, nonatomic) IBOutlet UIButton *moreBtn;


@end

@implementation ZPHomePageGoodsHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZPHomePageGoodsHeadView" owner:nil options:nil] lastObject];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)moreAction:(id)sender {
    
}

@end
