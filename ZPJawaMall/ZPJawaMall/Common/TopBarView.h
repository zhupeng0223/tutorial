//
//  TopBarView.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopBarView : UIView

@property (strong, nonatomic) IBOutlet UIButton *scanFunBtn;
@property (strong, nonatomic) IBOutlet UISearchBar *seachBar;
@property (strong, nonatomic) IBOutlet UIButton *localCountryBtn;
- (instancetype)initWithFrame:(CGRect)frame;

@end
