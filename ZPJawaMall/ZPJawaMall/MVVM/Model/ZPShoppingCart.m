//
//  ZPShoppingCart.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/10/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPShoppingCart.h"

@implementation ZPShoppingCart

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}

@end
