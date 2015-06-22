//
//  HYqiubaiController.m
//  HYZhener
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 HYZhener. All rights reserved.
//

#import "HYqiubaiController.h"
#import "HYContent.h"
#define HMTextFont [UIFont systemFontOfSize:13]
@interface HYqiubaiController ()

@property (nonatomic,strong)NSMutableArray * arr;
@property (nonatomic,assign)int page;

@end



@implementation HYqiubaiController



-(NSMutableArray *)arr{
    if (_arr ==nil) {
        
        
        //http://zhangbo520.cn/tools/qiubai.ashx?page=1
        
        
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"help.json" ofType:nil];
        NSString * uPath=[NSString stringWithFormat:@"http://zhangbo520.cn/tools/qiubai.ashx?page=%d",self.page];
        NSURL *url=[NSURL URLWithString:uPath];
        //NSURLRequest * request=[NSURLRequest requestWithURL:url];
        
        //加载json的二进制文件
        //NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSData *data=[NSData dataWithContentsOfURL:url];
        
       // NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
      // BOOL b= [data writeToFile:@"content.json" atomically:NO];
        //NSLog(@"%d",b);
        //[data writeToFile:@"content.json" atomically:YES];
        NSString * str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //NSURL * path=[NSURL URLWithString:@"/Users/apple/Music/HYZhener/HYZhener/content.json"];
        //[str writeToURL:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSData * data2=[str dataUsingEncoding:NSUTF8StringEncoding];
        
        //[str writeToFile:@"content.json" atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        
        //NSData *data3 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"content.json" ofType:nil]];
        //解析json 成数组
        //NSLog(@"%@",data);
        //NSLog(@"-------");
        //NSLog(@"%@",self.data);
        
        //data3=[NSData dataWithData:data2];
        
       //NSData * data4= [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError * err=[[NSError alloc]init];
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:&err] ;
       
        
        //字典转模型
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            HYContent *content = [HYContent contentWithDic:dic];
            [mArray addObject:content];
        }
        _arr = mArray;
        
        
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat f=[[UIScreen mainScreen] bounds].size.width-40;
    
    self.page=1;
    
    
    
    //CGFloat rh=80;
    //self.tableView.rowHeight=rh;
    UIView *headerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 20)];
    UILabel *lblCount=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 50, 20)];
    lblCount.text=[NSString stringWithFormat:@"第%d页",self.page];
    [headerView addSubview:lblCount];
    self.tableView.tableHeaderView=headerView;
    //self.tableView.separatorColor=[UIColor colorWithRed:211/255 green:211/255 blue:211/255 alpha:1];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.tableView.separatorInset=UIEdgeInsetsMake(200, 0, 200, 0);
    //self.tableView.backgroundColor=[UIColor lightGrayColor];
    //self.tableView.backgroundColor=[UIColor colorWithRed:251/255 green:252/255 blue:173/255 alpha:1];
     UIView *footerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, f+40, 60)];
    UIButton *btnNext=[[UIButton alloc]initWithFrame:CGRectMake(20, 5, f, 30)];
    [btnNext setTitle:@"下一页" forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //[btnNext sizeToFit];
    btnNext.backgroundColor= [UIColor redColor];
    
    [btnNext addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:btnNext];
    self.tableView.tableFooterView=footerView;
    
    
}

-(void)nextPage:(UIButton *) sender{
    self.page++;
    
    NSString * uPath=[NSString stringWithFormat:@"http://zhangbo520.cn/tools/qiubai.ashx?page=%d",self.page];
    NSURL *url=[NSURL URLWithString:uPath];
    
    NSData *data=[NSData dataWithContentsOfURL:url];
    

    NSString * str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSData * data2=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSError * err=[[NSError alloc]init];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:&err] ;
    
    HYContent *c=[[HYContent alloc]init];
    
    
    
    c.content=[NSString stringWithFormat:@"第%d页",self.page];
    [self.arr addObject:c];
    
    int count=(int)self.arr.count;
    
    //字典转模型
    //NSMutableArray *mArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HYContent *content = [HYContent contentWithDic:dic];
        [self.arr addObject:content];
        
    }
    
    
    [self.tableView reloadData];
    
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString * qiubaiID=@"qiubai";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%lu",(long)indexPath.row]];
    
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%lu",(long)indexPath.row]];
        NSArray * array= [cell subviews];
        for (UIView *view in array) {
            [view removeFromSuperview];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
        //cell.textLabel.numberOfLines=0;
        
        cell.backgroundColor=[UIColor colorWithRed:251/255 green:252/255 blue:173/255 alpha:0];
        
        
        
        
        HYContent *content= self.arr[indexPath.row];
        NSMutableAttributedString *coreText = [[NSMutableAttributedString alloc] initWithString:content.content];
        //段落---
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 12.0f;
        paragraph.firstLineHeadIndent = 20.0f;

        [coreText addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, coreText.length)];
        [coreText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, coreText.length)];
        
        
        
        //cell.textLabel.attributedText=coreText;
        //cell.textLabel.frame=CGRectMake(0, 0, 0, 600);
        //[cell.textLabel sizeToFit];
        CGFloat f=[[UIScreen mainScreen] bounds].size.width-40;
        
        
        
        //        NSMutableAttributedString *coreText = [[NSMutableAttributedString alloc] initWithString:self.arr[indexPath.row]];
        
        [coreText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, coreText.length)];
        
        //-----
        CGSize size =[coreText boundingRectWithSize:CGSizeMake(f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        UILabel * lbl=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, f, size.height+30)];
        lbl.attributedText=coreText;
        lbl.numberOfLines=0;
        lbl.lineBreakMode=NSLineBreakByWordWrapping;
        
        //lbl.bounds=CGRectMake(0, 0, f, size.height);
        
        
        
        [cell addSubview:lbl];
        
        
        
        UILabel *slbl=[[UILabel alloc]initWithFrame:CGRectMake(20, size.height+30,f, 1)];
        slbl.backgroundColor=[UIColor colorWithRed:211/255 green:211/255 blue:211/255 alpha:0.2];
        [cell addSubview:slbl];
        
    }
    
    
    return cell;
}

//+ (CGSize)sizeWithString: (NSMutableAttributedString *)coreText
//{
////    NSDictionary *attrs = @{NSFontAttributeName : font};
////    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//
//       //size = [aString boundingRectWithSize:CGSizeMake(237, 200)  options:NSStringDrawingUsesLineFragmentOriginattributes:diccontext:nil].size;
//
//
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // NSLog(@"%d",indexPath.row);
    CGFloat f=[[UIScreen mainScreen] bounds].size.width-40;
    //    CGSize textSize = [HYqiubaiController sizeWithString:self.arr[indexPath.row] font:HMTextFont maxSize:CGSizeMake(f, CGFLOAT_MAX)];
    //    CGFloat textH = textSize.height+50;
    //    NSLog(@"%f",textH);
    //----
   HYContent *content= self.arr[indexPath.row];
    NSMutableAttributedString *coreText = [[NSMutableAttributedString alloc] initWithString:content.content];
    [coreText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, coreText.length)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 12.0f;
    paragraph.firstLineHeadIndent = 20.0f;
    [coreText addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, coreText.length)];
    [coreText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, coreText.length)];
    
    //----
    CGSize size =[coreText boundingRectWithSize:CGSizeMake(f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    //NSLog(@"%lf",size.height);
    return size.height+30;
    
    
}



@end
