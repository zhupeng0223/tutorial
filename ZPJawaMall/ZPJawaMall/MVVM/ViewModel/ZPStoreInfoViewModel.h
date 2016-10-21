//
//  ZPStoreInfoViewModel.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/28.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ViewModelClass.h"

@interface ZPStoreInfoViewModel : ViewModelClass

- (void)getStoresInfoWithCity:(NSString *)city;
- (void)getEmployeesWithStoreName:(NSString *)name;

@end
