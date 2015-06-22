//
//  CZFriend.h
//  04QQ好友列表
//
//  Created by apple on 15/5/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYFriend : NSObject
@property (nonatomic,copy) NSString * id;

// 头像
@property (nonatomic, copy) NSString *icon;

// 个性签名
@property (nonatomic, copy) NSString *intro;

// 昵称
@property (nonatomic, copy) NSString *name;


// 是否是vip
@property(nonatomic, copy, getter=isVip) NSString * vip;

// 通讯id
@property (nonatomic, copy) NSString *sessionID;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)friendWithDict:(NSDictionary *)dict;

@end













