//
//  Model.h
//  Lesson16Request
//
//  Created by lanouhn on 15/9/23.
//  Copyright (c) 2015年 大爱海星星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *telephone;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
