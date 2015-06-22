//
//  NSString+NSStringForJava.h
//  NSStringCategory
//
//  Created by Ryan Tang on 12-10-17.
//  Copyright (c) 2012年 Ericsson Labs. All rights reserved.
//
#import <Foundation/Foundation.h>
//颜色
#define RGB(A, B, C)        [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]
@interface NSString (NSStringForHY)
/**判断字符串是否以指定的前缀开头*/
- (BOOL) startsWith:(NSString*)prefix;
/**判断字符串是否以指定的后缀结束*/
- (BOOL) endsWith:(NSString*)suffix;
/**转换成大写*/
- (NSString *) toLower;
/**转换成小写*/
- (NSString *) toUpper;
/**截取字符串前后空格*/
- (NSString *) trim;
/**用指定分隔符将字符串分割成数组*/
- (NSArray *) split:(NSString*) separator;
/**用指定字符串替换原字符串*/
- (NSString *) replace:(NSString*)oldStr with:(NSString*)newStr;
/**从指定的开始位置和结束位置开始截取字符串*/
- (NSString *) substringFromIndex:(int)begin toIndex:(int)end;
/**和其他字符串比较(不忽略大小写)*/
- (int) compareTo:(NSString*) anotherString;
/**和其他字符串比较,忽略大小写*/
- (int) compareToIgnoreCase:(NSString*) str;
/**是否包含*/
- (BOOL) contains:(NSString*) str;
/**是否完全相等*/
- (BOOL) equals:(NSString*) anotherString;
/**忽略大小写后是否相等*/
- (BOOL) equalsIgnoreCase:(NSString*) anotherString;
/**返回字符位置*/
- (int) indexOfChar:(unichar)ch;
- (int) indexOfChar:(unichar)ch fromIndex:(int)index;
- (int) indexOfString:(NSString*)str;
- (int) indexOfString:(NSString*)str fromIndex:(int)index;
- (int) lastIndexOfChar:(unichar)ch;
- (int) lastIndexOfChar:(unichar)ch fromIndex:(int)index;
- (int) lastIndexOfString:(NSString*)str;
- (int) lastIndexOfString:(NSString*)str fromIndex:(int)index;
@end