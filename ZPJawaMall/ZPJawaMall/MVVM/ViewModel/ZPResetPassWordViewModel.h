//
//  ZPResetPassWordViewModel.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ViewModelClass.h"

@interface ZPResetPassWordViewModel : ViewModelClass

- (void)getVerificationCodeWithPhoneNumber:(NSString *)phone;
- (void)resetPassWord;

@end
