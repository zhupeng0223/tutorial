//
//  ZPClassificationDetailsViewModel.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/20.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ViewModelClass.h"

@interface ZPClassificationDetailsViewModel : ViewModelClass

- (void)getClassificationListDetailsWithName:(NSString *)name;
- (void)getClassificationListDetailsWithId:(NSString *)ID;

@end
