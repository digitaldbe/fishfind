//
//  NewPathViewController.m
//  fishFind
//
//  Created by ioschen on 13-11-13.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import "NewPathViewController.h"

@interface NewPathViewController ()

@end

@implementation NewPathViewController
@synthesize danweiLable;
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
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"路径设置"];
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(back)];
    //把导航栏集合添加入导航栏中，设置动画关闭
    [navigationBar pushNavigationItem:navigationItem animated:NO];

    [navigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    
    [self makeshuru];
}
#pragma mark 输入
-(void)makeshuru
{
    UILabel *nameLable=[[UILabel alloc]initWithFrame:CGRectMake(80, 60, 100, 30)];
    nameLable.text=@"名称";
    [self.view addSubview:nameLable];
    nameText=[[UITextField alloc]initWithFrame:CGRectMake(60, 90, 100, 30)];
    nameText.backgroundColor=[UIColor redColor];
    nameText.delegate=self;
    [nameText addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nameText];
    
    UILabel *maxLable=[[UILabel alloc]initWithFrame:CGRectMake(60, 120, 180, 30)];
    maxLable.text=@"最大路径点数";
    [self.view addSubview:maxLable];
    maxText=[[UITextField alloc]initWithFrame:CGRectMake(60, 150, 100, 30)];
    maxText.backgroundColor=[UIColor redColor];
    maxText.delegate=self;
    maxText.keyboardType=UIKeyboardTypeNumberPad;
    [maxText addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:maxText];
    
    UILabel *setLable=[[UILabel alloc]initWithFrame:CGRectMake(60, 180, 150, 30)];
    setLable.text=@"设置路径点";//保存路径点.rubbish
    [self.view addSubview:setLable];
    UILabel *meiLable=[[UILabel alloc]initWithFrame:CGRectMake(60, 210, 40, 30)];
    meiLable.text=@"每";
    [self.view addSubview:meiLable];
    meiText=[[UITextField alloc]initWithFrame:CGRectMake(90, 210, 60, 30)];
    meiText.backgroundColor=[UIColor redColor];
    meiText.delegate=self;
    meiText.keyboardType=UIKeyboardTypeNumberPad;
    [meiText addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:meiText];
    danweiLable=[[UILabel alloc]initWithFrame:CGRectMake(120, 210, 100, 30)];
    //danweiLable.text=@"单位";
    [self.view addSubview:danweiLable];
    //加两个按钮，上加下减
    
    UIButton *startButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    startButton.frame=CGRectMake(60, 260, 80, 40);
    [startButton setTitle:@"start" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startPath) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];//判断有无信号
    
    
    //之前将path变为save
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)back
{
    self.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self dismissModalViewControllerAnimated:YES];
}
-(void)startPath
{
    //先判断有无GPS
    
    //还要判断最大路径点数和没秒米的单位数量是否数字
    if (nameText.text==nil || meiText.text==nil ||maxText.text==nil) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"请把信息填写完整" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
        [alert show];
    }else{
        NSUserDefaults * settings=[NSUserDefaults standardUserDefaults];//定义一个对象进行初始化
        //[settings removeObjectForKey:@"UserName"];//移除键值为UseName和Password的对象
        //[settings removeObjectForKey:@"Password"];//防止数据混乱造成干扰
        [settings setObject:nameText.text forKey:@"nameText"];//重新设置键值信息
        [settings setObject:maxText.text forKey:@"maxText"];
        [settings setObject:meiText.text forKey:@"meiText"];
        NSLog(@"保存设置路径信息成功");
        //[settings synchronize];//将键值信息同步道本地
        
        //通知地图那可以执行记录点的方法
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
