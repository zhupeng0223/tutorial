//
//  GoodsDetail.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetail : NSObject

@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *goodsname;
@property (nonatomic, copy) NSString *picurl;
@property (nonatomic, copy) NSString *goodsdesc;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *price_old;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *price_old1;
@property (nonatomic, copy) NSString *price1;
@property (nonatomic, copy) NSString *guide;
@property (nonatomic, copy) NSString *Tag;
@property (nonatomic, assign) NSInteger ordermoney;
@property (nonatomic, assign) NSInteger ordercount;

@end
