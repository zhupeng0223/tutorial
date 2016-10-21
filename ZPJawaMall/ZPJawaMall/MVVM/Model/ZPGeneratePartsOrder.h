//
//  ZPGeneratePartsOrder.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/10/19.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPGeneratePartsOrder : NSObject

@property (nonatomic, assign) NSInteger superbillid;
@property (nonatomic, assign) NSInteger allSchedprice; //总价
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *price;

@end
