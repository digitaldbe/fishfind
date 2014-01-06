//
//  PathViewController.m
//  fishFind
//
//  Created by ioschen on 13-11-18.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import "PathViewController.h"
#import "PathPointViewController.h"
@interface PathViewController ()

@end

@implementation PathViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(back)];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"显示"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(clickRightButton)];
        [navigationItem setTitle:@"路径详情"];
        [navigationBar pushNavigationItem:navigationItem animated:NO];
        [navigationItem setLeftBarButtonItem:leftButton];
        [navigationItem setRightBarButtonItem:rightButton];
        [self.view addSubview:navigationBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(20, 87, 80, 40);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(lookButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)lookButton:(id)sender
{
    PathPointViewController* pathPoint=[[PathPointViewController alloc]init];
    [self presentViewController:pathPoint animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
