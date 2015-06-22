//
//  HYContent.h
//  HYZhener
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 HYZhener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYContent : NSOperation
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *cid;

+ (instancetype)contentWithDic:(NSDictionary *)dic;
@end
