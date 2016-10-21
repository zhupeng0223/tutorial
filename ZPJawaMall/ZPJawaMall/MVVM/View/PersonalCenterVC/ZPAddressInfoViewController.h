//
//  ZPAddressInfoViewController.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/22.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "BassViewController.h"
@class ZPAddress;
@interface ZPAddressInfoViewController : BassViewController

@property (nonatomic, copy) NSString *UID;
@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, strong) ZPAddress *upAddress;

@end
