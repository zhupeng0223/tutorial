//
//  GoodsList.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsList : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *picurl;
@property (nonatomic, copy) NSString *goodsname;
@property (nonatomic, assign) NSInteger myordercount;
@property (nonatomic, assign) NSInteger mycommentcount;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *price1;
@property (nonatomic, copy) NSString *price_old;
@property (nonatomic, copy) NSString *price_old1;

@end
