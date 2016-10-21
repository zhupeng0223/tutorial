//
//  ZPShoppingCart.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/10/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ViewModelClass.h"

@interface ZPShoppingCart : ViewModelClass

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *goodsname;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *buycount;

@end
