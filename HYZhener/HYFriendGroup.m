//
//  HYFriendGroup.m
//  HYZhener
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 HYZhener. All rights reserved.
//

#import "HYFriendGroup.h"
#import "HYFriend.h"

@implementation HYFriendGroup

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        // 把字典转模型
        NSMutableArray *arrayModels = [NSMutableArray array];
        for (NSDictionary *dict_f in self.friends) {
            HYFriend *model = [HYFriend friendWithDict:dict_f];
            [arrayModels addObject:model];
        }
        self.friends = arrayModels;
    }
    return self;
}

+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
