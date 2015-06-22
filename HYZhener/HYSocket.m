//
//  HYSocket.m
//  HYZhener
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 HYZhener. All rights reserved.
//

#import "HYSocket.h"
#import "AsyncSocket.h"
#import "Person.h"
#import "AppDelegate.h"
#import "CommonFunc.h"
#define ip @"192.168.35.121"

@interface HYSocket ()<AppDelegateDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AsyncSocket *socket;

@property (nonatomic,strong) NSMutableArray * arr;

@property (nonatomic,weak)IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UIView *topView;

- (IBAction)sendBtn:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tablebm;


@end

@implementation HYSocket

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


- (void)keyboardChanged:(NSNotification *)n {
    NSLog(@"%@", n);
    
    // 字典和数组中不能保存基本类型(NSNumber)以及结构体(NSValue)
    // 键盘rect
    CGRect rect = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomConstraint.constant = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
    
    // 动画时长
    NSTimeInterval duration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //[UIScreen mainScreen].bounds.size.height - rect.origin.y;
    //self.tablebm.constant=0;
    
    self.tablebm.constant=0;
    
    // 动画
    [UIView animateWithDuration:duration animations:^{
        // 更新布局
        [self.view layoutIfNeeded];
    }];
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];


    // 利用通知监听键盘变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    //    self observeValueForKeyPath:<#(NSString *)#> ofObject:<#(id)#> change:<#(NSDictionary *)#> context:<#(void *)#>
    
    
    //全局代理
    //    AppDelegate *appDD = [[UIApplication sharedApplication] delegate];
    //
    //    appDD.delegate=self;
    
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 1)];
    
    UIView *HYView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
    //  UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 180, 35)];
    
    //text.backgroundColor = [UIColor whiteColor];
    
    //   UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(180, 0, 30, 30)];
    
    //    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //
    //    [btn setTitle:@"send" forState:UIControlStateNormal];
    //
    //    [btn sizeToFit];
    //
    //    [btn addTarget:self action:@selector(clickSend) forControlEvents:UIControlEventTouchUpInside];
    
    // [HYView addSubview:btn];
    
    //  [HYView addSubview:text];
    
    // self.text = text;
    
    self.tableView.tableFooterView = HYView;
    
    self.socket=[[AsyncSocket alloc]initWithDelegate:self];
    
    
    
    [self.socket connectToHost:ip onPort:60623 error:nil];
    
    
}



// 发送数据
- (void) sendMsg:(NSString *)message
{
    NSLog(@"聊天发出:%@",message);
    NSString * str= [CommonFunc base64StringFromText:message];
    
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.socket writeData:data withTimeout:15 tag:0];
    
}

/**连接成功*/
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"\n 地址:%@  \n 端口:%@",host,@(port));

    [self.socket readDataWithTimeout:-1 tag:0];

    NSLog(@"连接成功");
}

/**读取数据*/
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSString* message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"聊天%@",message);
  // NSString * strDeCode =[CommonFunc textFromBase64String:message];

    Person * p = [Person new];
//    if (strDeCode == nil) {
//        p.message=message;
//    }else{
//        p.message = strDeCode;
//    }
    p.message=message;

    p.iswho = 1;

    [self.arr addObject:p];

    [self.socket readDataWithTimeout:-1 tag:0];

    [self.tableView reloadData];

    // NSLog(@" 收到:%@",message);



}
/**关闭socket*/
- (void)onSocketDidDisconnect:(AsyncSocket *)sock{

    NSLog(@"socket关闭");
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%lu",(long)indexPath.row]];
    Person *p = self.arr[indexPath.row];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%lu",(long)indexPath.row]];
        //if (((Person *)self.arr[indexPath.row]).iswho) {
        //不是我
        //cell.textLabel.textAlignment=NSTextAlignmentRight;
        
        //}
        
        NSMutableAttributedString *coreText = [[NSMutableAttributedString alloc] initWithString:p.message];
        
        //段落---
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        
        paragraph.lineSpacing = 12.0f;
        
        paragraph.firstLineHeadIndent = 20.0f;
        
        [coreText addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, coreText.length)];
        
        [coreText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, coreText.length)];
        
        CGFloat f = [[UIScreen mainScreen] bounds].size.width-40;
        
        [coreText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, coreText.length)];
        
        //计算
        CGSize size =[coreText boundingRectWithSize:CGSizeMake(f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        
        UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, f, size.height+30)];
        
        lbl.attributedText = coreText;
        
        lbl.numberOfLines = 0;
        
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
        
        [cell addSubview:lbl];
        
        UILabel *slbl=[[UILabel alloc]initWithFrame:CGRectMake(20, size.height,f, 1)];
        
        slbl.backgroundColor=[UIColor colorWithRed:211/255 green:211/255 blue:211/255 alpha:0.2];
        
        [cell addSubview:slbl];
        
        
    }
    return cell;
}

#warning 待修改
/**计算行高(待修改)*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // NSLog(@"%d",indexPath.row);
    CGFloat f=[[UIScreen mainScreen] bounds].size.width-40;
    //    CGSize textSize = [HYqiubaiController sizeWithString:self.arr[indexPath.row] font:HMTextFont maxSize:CGSizeMake(f, CGFLOAT_MAX)];
    //    CGFloat textH = textSize.height+50;
    //    NSLog(@"%f",textH);
    //----
    Person *p= self.arr[indexPath.row];
    NSMutableAttributedString *coreText = [[NSMutableAttributedString alloc] initWithString:p.message];
    [coreText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, coreText.length)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 12.0f;
    paragraph.firstLineHeadIndent = 20.0f;
    [coreText addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, coreText.length)];
    [coreText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, coreText.length)];
    
    //----
    CGSize size =[coreText boundingRectWithSize:CGSizeMake(f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    //NSLog(@"%lf",size.height);
    return size.height;
}


/**懒加载*/
-(NSMutableArray *)arr{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}
/**被激活执行*/
-(void)AppDelegateWithAppActive{
    
    [self.socket disconnect];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.socket disconnect];
    NSLog(@"yaxiaoshi");
    
}
/**进入后台执行*/
-(void)AppDelegateWithAppForeground{
    
    self.socket=[[AsyncSocket alloc]initWithDelegate:self];
    
    //* socket = [[AsyncSocket alloc] initWithDelegate:self];
    
    //[self.socket connectToHost:@"118.193.179.190" onPort:60623 error:nil];
}

-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"我挂了");
}

- (IBAction)sendBtn:(id)sender {
    
    Person * p = [Person new];
    p.message = self.text.text;
    p.iswho = 0;
    
    
    
    NSString * strEncode=[CommonFunc base64StringFromText:p.message];
    
    //NSString * str = [NSString stringWithFormat:@"echo 11 \r\n",self.friendID];
    NSString * str = [NSString stringWithFormat:@"list \r\n"];
    
    
    [self sendMsg:str];
    
    self.text.text = @"";
    
    [self.view endEditing:YES];
    
    NSLog(@"%@",str);
    
    //[self.tableView reloadData];
    
    //if (self.arr.count != 0) {
    
    
    //NSIndexPath *idxPath = [NSIndexPath indexPathForRow:self.arr.count-1 inSection:0];
    
    //[self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    
    
    //}
    
}
@end
