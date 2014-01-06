//
//  MenuViewController.m
//  fishFind
//
//  Created by ioschen on 13-11-8.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self CGRectMakeNavigationBar];
    [self CGRectMakeLabel];
}

-(void)CGRectMakeNavigationBar
{
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(clickRightButton)];
    //设置导航栏内容
    [navigationItem setTitle:@"GPS参数设置"];
    //把导航栏集合添加入导航栏中，设置动画关闭
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    //把左右两个按钮添加入导航栏集合中
    [navigationItem setLeftBarButtonItem:leftButton];
    [navigationItem setRightBarButtonItem:rightButton];
    //把导航栏添加到视图中
    [self.view addSubview:navigationBar];
}
-(void)CGRectMakeLabel
{
    UILabel *gs=[[UILabel alloc]initWithFrame:CGRectMake(40, 60, 300, 40)];
    gs.text=@"单位格式    //公制";
    
    UILabel *jw=[[UILabel alloc]initWithFrame:CGRectMake(40, 100, 300, 40)];
    jw.text=@"经纬度格式      //度分";
    
    UILabel *ry=[[UILabel alloc]initWithFrame:CGRectMake(40, 140, 300, 40)];
    ry.text=@"日月计算器    //关";
    
    UILabel *sq=[[UILabel alloc]initWithFrame:CGRectMake(40, 180, 300, 40)];
    sq.text=@"时区设置   //GMT+08";
    
    UILabel *dd=[[UILabel alloc]initWithFrame:CGRectMake(40, 220, 300, 40)];
    dd.text=@"到达报警    //关";
    
    UILabel *ph=[[UILabel alloc]initWithFrame:CGRectMake(40, 260, 300, 40)];
    ph.text=@"偏航报警     //关";
    
    UILabel *md=[[UILabel alloc]initWithFrame:CGRectMake(40, 300, 320, 40)];
    md.text=@"锚地漂移报警   //关";
    [self.view addSubview:jw];
    [self.view addSubview:ry];
    [self.view addSubview:sq];
    [self.view addSubview:dd];
    [self.view addSubview:ph];
    [self.view addSubview:md];
    [self.view addSubview:gs];
    /*
     1：单位制式   -- 设置距离、速度等的单位制式，分别为英制和公制。
     经纬度格式 -- 度度(29.956度) 或 度分(29度58.632分)
     2：日月计算器 -- 用于计算日出日落，月出月落时间并显示
     3：时区设置  --  用于设置当前所在的时区，也可以设为自动(根据经度来自动计算)
     4：到达报警 -- 用于导航时，距离目的地多长距离时报警。
     5：偏航报警 -- 用于导航时，偏离轨迹多长距离时报警。
     6：锚地飘移报警 -- 用于停船时，飘移了锚地多长距离时报警。

     */
}


-(void)clickLeftButton
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)clickRightButton
{
    [self showDialog:@"点击了导航栏右边按钮"];
}
-(void)showDialog:(NSString *) str
{
    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"这是一个对话框" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
