//
//  ZPChooseAddressTableViewCell.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPAddress;

@interface ZPChooseAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) ZPAddress *address;
@property (nonatomic, assign) BOOL isSelected;

@end
