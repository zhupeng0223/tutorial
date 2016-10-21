//
//  ZPPersonViewModel.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/22.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ViewModelClass.h"

@interface ZPPersonViewModel : ViewModelClass

- (void)getUserOrderWithUID:(NSString *)uid;
- (void)getActivityInfo;

- (void)getAddress:(NSString *)uid;
- (void)editNewAddressWithInfo:(NSDictionary *)info;

@end
