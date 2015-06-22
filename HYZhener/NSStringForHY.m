//
//  NSString+NSStringForJava.m
//  NSStringCategory
//
//  Created by Ryan Tang on 12-10-17.
//  Copyright (c) 2012年 Ericsson Labs. All rights reserved.
//
#import "NSStringForHY.h"
@implementation NSString (NSStringForHY)
#pragma mark 判断字符串是否以指定的前缀开头
/**判断字符串是否以指定的前缀开头*/
- (BOOL) startsWith:(NSString*)prefix
{
    return [self hasPrefix:prefix];
}
#pragma mark 断字符串是否以指定的后缀结束
/**判断字符串是否以指定的后缀结束*/
- (BOOL) endsWith:(NSString*)suffix
{
    return [self hasSuffix:suffix];
}
#pragma mark 转换成小写
/**转换成小写*/
- (NSString *) toLower
{
    return [self lowercaseString];
}
#pragma mark 转换成大写
/**转换成大写*/
- (NSString *) toUpper
{
    return [self uppercaseString];
}
#pragma mark 截取字符串前后空格
/**截取字符串前后空格*/
- (NSString *) trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
#pragma mark 用指定分隔符将字符串分割成数组
/**用指定分隔符将字符串分割成数组*/
- (NSArray *) split:(NSString*) separator
{
    return [self componentsSeparatedByString:separator];
}
#pragma mark 指定字符串替换原字符串
/**用指定字符串替换原字符串*/
- (NSString *) replace:(NSString*)oldStr with:(NSString*)newStr
{
    return [self stringByReplacingOccurrencesOfString:oldStr withString:newStr];
}
#pragma mark 从指定的开始位置和结束位置开始截取字符串
/**从指定的开始位置和结束位置开始截取字符串*/
- (NSString *) substringFromIndex:(int)begin toIndex:(int)end
{
    if (end <= begin) {
        return @"";
    }
    NSRange range = NSMakeRange(begin, end - begin);
    return [self substringWithRange:range];
}
#define NotFound -1
#pragma mark 取第几个位置的字符
/**取第几个位置的字符*/
- (unichar) charAt:(int)index {
    return [self characterAtIndex:index];
}
#pragma mark 和其他字符串比较(不忽略大小写)
/**和其他字符串比较(不忽略大小写)*/
- (int) compareTo:(NSString*) anotherString {
    return [self compare:anotherString];
}
#pragma mark 和其他字符串比较,忽略大小写
/**和其他字符串比较,忽略大小写*/
- (int) compareToIgnoreCase:(NSString*) str {
    return [self compare:str options:NSCaseInsensitiveSearch];
}
#pragma mark 是否包含
/**是否包含*/
- (BOOL) contains:(NSString*) str {
    NSRange range = [self rangeOfString:str];
    return (range.location != NSNotFound);
}
#pragma mark 是否完全相等
/**是否完全相等*/
- (BOOL) equals:(NSString*) anotherString {
    return [self isEqualToString:anotherString];
}
#pragma mark 忽略大小写后是否相等
/**忽略大小写后是否相等*/
- (BOOL) equalsIgnoreCase:(NSString*) anotherString {
    return [[self toLower] equals:[anotherString toLower]];
}
#pragma mark 返回字符位置
/**返回字符位置*/
- (int) indexOfChar:(unichar)ch{
    return [self indexOfChar:ch fromIndex:0];
}
- (int) indexOfChar:(unichar)ch fromIndex:(int)index{
    int len = (int)self.length;
    for (int i = index; i < len; ++i) {
        if (ch == [self charAt:i]) {
            return i;
        }
    }
    return NotFound;
}
- (int) indexOfString:(NSString*)str {
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound) {
        return NotFound;
    }
    return (int)range.location;
}
- (int) indexOfString:(NSString*)str fromIndex:(int)index {
    NSRange fromRange = NSMakeRange(index, self.length - index);
    NSRange range = [self rangeOfString:str options:NSLiteralSearch range:fromRange];
    if (range.location == NSNotFound) {
        return NotFound;
    }
    return (int)range.location;
}
- (int) lastIndexOfChar:(unichar)ch {
    int len = (int)self.length;
    for (int i = len-1; i >=0; --i) {
        if ([self charAt:i] == ch) {
            return i;
        }
    }
    return NotFound;
}
- (int) lastIndexOfChar:(unichar)ch fromIndex:(int)index {
    int len = (int)self.length;
    if (index >= len) {
        index = len - 1;
    }
    for (int i = index; i >= 0; --i) {
        if ([self charAt:i] == ch) {
            return index;
        }
    }
    return NotFound;
}
- (int) lastIndexOfString:(NSString*)str {
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return NotFound;
    }
    return (int)range.location;
}
- (int) lastIndexOfString:(NSString*)str fromIndex:(int)index {
    NSRange fromRange = NSMakeRange(0, index);
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch range:fromRange];
    if (range.location == NSNotFound) {
        return NotFound;
    }
    return (int)range.location;
}
@end