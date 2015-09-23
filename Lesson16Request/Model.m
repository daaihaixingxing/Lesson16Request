//
//  Model.m
//  Lesson16Request
//
//  Created by lanouhn on 15/9/23.
//  Copyright (c) 2015年 大爱海星星. All rights reserved.
//

#import "Model.h"

@implementation Model

- (void)dealloc {
    [_name release];
    [_address release];
    [_telephone release];
    [super dealloc];
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return  self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"key值不存在(⊙o⊙)哦,%@",key);
}

@end
