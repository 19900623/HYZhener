//
//  HYTestController.m
//  HYZhener
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 HYZhener. All rights reserved.
//

#import "HYTestController.h"

@interface HYTestController ()

@end

@implementation HYTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"123" message:@"123" delegate:self cancelButtonTitle:@"123" otherButtonTitles: nil];
    
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{

    NSLog(@"guale");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
