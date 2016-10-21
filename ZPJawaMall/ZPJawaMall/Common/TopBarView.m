//
//  TopBarView.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "TopBarView.h"

@interface TopBarView ()

@end

@implementation TopBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TopBarView" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

@end
