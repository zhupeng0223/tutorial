//
//  GoodsInfo.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "GoodsInfo.h"
#import "Color.h"
#import "Taimian.h"
#import "Door.h"

@implementation GoodsInfo

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    if ([key isEqualToString:@"detail"]) {
//        
//    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"detail"]) {
        self.detail = [[GoodsDetail alloc] init];
        [self.detail setValuesForKeysWithDictionary:value];
    }else if ([key isEqualToString:@"colors"]) {
        self.colors = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            Color *color = [[Color alloc] init];
            [color setValuesForKeysWithDictionary:dic];
            [self.colors addObject:color];
        }
    }else if ([key isEqualToString:@"taimian"]) {
        self.taimian = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            Taimian *taimian = [[Taimian alloc] init];
            [taimian setValuesForKeysWithDictionary:dic];
            [self.taimian addObject:taimian];
        }
    }else if ([key isEqualToString:@"door"]) {
        self.door = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            Door *door = [[Door alloc] init];
            [door setValuesForKeysWithDictionary:dic];
            [self.door addObject:door];
        }
    }else {
        [super setValue:value forKey:key];
    }
}

@end
