//
//  Order.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/22.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, copy) NSString *erpstatus;
@property (nonatomic, copy) NSString *subbillid;
@property (nonatomic, copy) NSString *superbillid;
@property (nonatomic, copy) NSString *picurl;
@property (nonatomic, copy) NSString *goodsname;
@property (nonatomic, copy) NSString *billprice;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *schedprice;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *yyid;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *buynum;

@end
