//
//  ZPPersonalCenterViewController.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "BassViewController.h"
#import "UserInfo.h"

typedef void (^ReturnUserInfoBlock) (UserInfo *value);

@interface ZPPersonalCenterViewController : BassViewController

@property (nonatomic, copy) ReturnUserInfoBlock returnUserInfoBlock;

@end
