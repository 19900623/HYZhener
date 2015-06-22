//
//  HYFriendGroup.h
//  HYZhener
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 HYZhener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYFriendGroup : NSObject

@property (nonatomic, copy) NSString *name;

// 在线人数
@property(nonatomic, assign)int online;

// 好友
@property(nonatomic, strong)NSArray *friends;


// 控制组的现实与闭合
@property (nonatomic, assign, getter=isVisible) BOOL visible;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)groupWithDict:(NSDictionary *)dict;

@end
