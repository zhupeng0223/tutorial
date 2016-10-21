//
//  ZPShoppingCartViewModel.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/10/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ViewModelClass.h"

@interface ZPShoppingCartViewModel : ViewModelClass

- (void)addShoppingCartWithParam:(NSDictionary *)param;
- (void)getShoppingCarWithUID:(NSString *)uid;

- (void)checkShoppingCartWithParam:(NSDictionary *)param;
- (void)checkShoppingCartProductsWithParam:(NSDictionary *)param;
- (void)checkShoppingCartGenerateHomeOrderWithParam:(NSDictionary *)param;

@end
