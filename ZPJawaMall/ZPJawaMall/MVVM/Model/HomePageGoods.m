//
//  HomePageGoods.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/30.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "HomePageGoods.h"

@implementation HomePageGoods

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}

@end
