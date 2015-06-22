//
//  AppDelegate.h
//  HYZhener
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 HYZhener. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@protocol AppDelegateDelegate <NSObject>
@optional
- (void)AppDelegateWithAppActive;
- (void)AppDelegateWithAppForeground;
@end








@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) id<AppDelegateDelegate> delegate;

@end

