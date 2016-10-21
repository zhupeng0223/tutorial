//
//  ZPClassTitle.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/19.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPClassTitle.h"

@implementation ZPClassTitle

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = [value integerValue];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}


@end
