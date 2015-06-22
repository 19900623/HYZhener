//
//  HYFirendListController.m
//  HYZhener
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 HYZhener. All rights reserved.
//

#import "HYFirendListController.h"
#import "HYFriendGroup.h"
#import "HYFriend.h"
#import "HYSocket.h"
#import "HYTestController.h"
#import "AsyncSocket.h"
#define ip @"192.168.35.121"
@interface HYFirendListController ()<UITableViewDelegate>

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, weak) UIButton *btnTitle;
@property (nonatomic, strong) NSArray *groups;


@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) AsyncSocket *socket;

@end

@implementation HYFirendListController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.sectionHeaderHeight = 44;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.navigationItem.title=@"好友列表";
    
    UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightClick)];
    self.navigationItem.backBarButtonItem = rItem;
    rItem.title = @"刷新吧骚年";
    
    
    self.navigationItem.rightBarButtonItem=rItem;
    
    //AsyncSocket * socket = [[AsyncSocket alloc] initWithDelegate:self];
    
    self.socket=[[AsyncSocket alloc]initWithDelegate:self];
    [self.socket connectToHost:ip onPort:60623 error:nil];
    
    
}
-(void)rightClick{
    
    [self sendMsg:@"list\r\n"];
    
    self.groups=nil;
    
}
// 发送数据
- (void) sendMsg:(NSString *)message
{
    NSLog(@"发出:%@",message);
    
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [self.socket writeData:data withTimeout:15 tag:0];
    
}

/**连接成功*/
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"\n 地址:%@  \n 端口:%@",host,@(port));
    
    [self.socket readDataWithTimeout:-1 tag:0];
    
    NSLog(@"连接成功");
    [self sendMsg:@"list\r\n"];
}

/**读取数据*/
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSLog(@"%@",data);
    NSString* message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",message);
    if ([message isEqualToString:@"Welcome to SuperSocket Telnet Server"]) {
        NSLog(@"%@",message);
        return;
    }
    self.list= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    

    
    [self.socket readDataWithTimeout:-1 tag:0];
    
    [self.tableView reloadData];
    
    NSLog(@" 收到:%@",self.list);
    
    
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"123" message:message delegate:self cancelButtonTitle:@"quxiao" otherButtonTitles: nil];
//    [alert show];
    
}
/**关闭socket*/
- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    
    NSLog(@"socket关闭");
    
}


//===========================================================================
- (void)headerViewDidClickGroupTitleButton:(NSUInteger)headerIndex
{
    
    // 局部刷新(点击哪一组, 刷新哪一组)
    NSIndexSet *idxSet = [NSIndexSet indexSetWithIndex:headerIndex];
    [self.tableView reloadSections:idxSet withRowAnimation:UITableViewRowAnimationAutomatic];
}


-(void)btnTitleClick:(UIButton *)sender{
    
    long idx=sender.tag;
    HYFriendGroup * agroup=self.groups[idx];
    [agroup setVisible:!agroup.isVisible];
    
    [self headerViewDidClickGroupTitleButton:sender.tag];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton *btnTitle = [[UIButton alloc] init];
    self.btnTitle=btnTitle;
    // 设置按钮中的图片的现实模式
    btnTitle.imageView.contentMode = UIViewContentModeCenter;
    // 设置超出部分不要截取掉
    btnTitle.imageView.layer.masksToBounds = NO;
    
    // 设置按钮中的"三角图片"
    [btnTitle setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
    // 设置按钮的背景图片
    [btnTitle setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:UIControlStateNormal];
    [btnTitle setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:UIControlStateHighlighted];
    
    // 设置按钮的文字颜色
    [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // 设置按钮中的内容整体左对齐
    btnTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 设置按钮中的内容的左侧的内边距
    btnTitle.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    // 设置按钮中的标题文字的左侧内边距
    btnTitle.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    // 为按钮注册一个点击事件
    [btnTitle addTarget:self action:@selector(btnTitleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnTitle setTitle:((HYFriendGroup *)self.groups[section]).name forState:UIControlStateNormal];
    
    static NSString *ID = @"group_headerView";
    UITableViewHeaderFooterView *headerVw = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headerVw == nil) {
        headerVw = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
    }
    
    [btnTitle sizeToFit];
    
    btnTitle.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    
    
    
    
    [headerVw addSubview:btnTitle];
    
    // 2. 标签
    UILabel *lblOnLine = [[UILabel alloc] init];
    // 设置label的背景色
    //lblOnLine.backgroundColor = [UIColor redColor];
    // 设置Label中的文字右对齐
    lblOnLine.textAlignment = NSTextAlignmentRight;
    
    
    
    [headerVw addSubview:lblOnLine];
    
    btnTitle.tag = section;
    headerVw.tag=section;
    
    
    
    if (((HYFriendGroup *)self.groups[section]).isVisible) {
        // 如果组是可见的, 那么就把小三角图片向下旋转90°，展开该组
        // 让按钮中的三角图片进行旋转
        self.btnTitle.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.btnTitle.imageView.transform = CGAffineTransformMakeRotation(0);
    }
    
    return headerVw;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSLog(@"刷新");
    if (self.groups.count==0) {
        return 0;
    }else{
        return self.groups.count;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 1. 获取组模型
    HYFriendGroup *group = self.groups[section];
    if (group.isVisible) {
        return group.friends.count;
    } else {
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // 1. 获取模型数据
    HYFriendGroup *group = self.groups[indexPath.section];
    HYFriend *friendModel = group.friends[indexPath.row];
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    cell.imageView.image = [UIImage imageNamed:friendModel.icon];
    cell.textLabel.text = friendModel.name;
    cell.detailTextLabel.text = friendModel.intro;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // 判断如果是会员的话, 设置设置昵称的label为红色
    if (friendModel.isVip) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
    
}


/**------layzload---------*/
- (NSArray *)groups
{
    
    
    
    if (_groups == nil) {
        if (self.list.count>0) {
            NSMutableArray *arrayModels=[NSMutableArray array];
            for (NSDictionary *dict in self.list) {
                HYFriendGroup *model = [HYFriendGroup groupWithDict:dict];
                [arrayModels addObject:model];
            }
            _groups = arrayModels;
            NSLog(@"%@",arrayModels);
        }
        
    }
    return _groups;
}



-(NSMutableArray *)list{
    if (_list==nil) {
        _list =[NSMutableArray array];
    }
    return _list;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HYSocket * socket=[self.storyboard instantiateViewControllerWithIdentifier:@"socket"];
    
    socket.hidesBottomBarWhenPushed=YES;
    
    HYFriendGroup *group = self.groups[indexPath.section];
    HYFriend *friendModel = group.friends[indexPath.row];
    socket.friendID=friendModel.sessionID;
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回吧骚年";
    
    [self.navigationController pushViewController:socket animated:true];
    
}
@end
