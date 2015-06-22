//
//  HYContent.m
//  HYZhener
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 HYZhener. All rights reserved.
//

#import "HYContent.h"

@implementation HYContent
+ (instancetype)contentWithDic:(NSDictionary *)dic{
    HYContent *content = [HYContent new];
    
    [content setValuesForKeysWithDictionary:dic];
    return content;
}

@end
