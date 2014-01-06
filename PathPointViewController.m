//
//  PathPointViewController.m
//  fishFind
//
//  Created by ioschen on 13-11-18.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import "PathPointViewController.h"
#import "PointViewController.h"
@interface PathPointViewController ()

@end

@implementation PathPointViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
        [navigationItem setTitle:@"路径点列表"];
        //把导航栏集合添加入导航栏中，设置动画关闭
        [navigationBar pushNavigationItem:navigationItem animated:NO];
        
        [self.view addSubview:navigationBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(20 , 62, 80, 40);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self CGRectMakeButton];
}
-(void)next
{
    //didselect
    PointViewController* pointView=[[PointViewController alloc]init];
    [self presentViewController:pointView animated:YES completion:nil];
}

#pragma mark - tab
-(void)CGRectMakeButton
{
    UIButton *savebutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    savebutton.frame=CGRectMake(0, self.view.frame.size.height-40, 80, 40);
    [savebutton setTitle:@"去钓点" forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savebutton];
    
    UIButton *delbutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    delbutton.frame=CGRectMake(80, self.view.frame.size.height-40, 80, 40);
    [delbutton setTitle:@"删除" forState:UIControlStateNormal];
    [delbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delbutton];
    
    UIButton *mapbutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    mapbutton.frame=CGRectMake(160, self.view.frame.size.height-40, 80, 40);
    [mapbutton setTitle:@"沿路径去" forState:UIControlStateNormal];
    [mapbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapbutton];
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    backbutton.frame=CGRectMake(240, self.view.frame.size.height-40, 80, 40);
    [backbutton setTitle:@"返回" forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
}
-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
