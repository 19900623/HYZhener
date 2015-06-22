//
//  CZFriend.m
//  04QQ好友列表
//
//  Created by apple on 15/5/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "HYFriend.h"

@implementation HYFriend

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)friendWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
