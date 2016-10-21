//
//  ZPLoginViewModel.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/1.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ViewModelClass.h"

@interface ZPLoginViewModel : ViewModelClass

- (void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord;

@end
