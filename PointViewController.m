//
//  PointViewController.m
//  fishFind
//
//  Created by ioschen on 13-11-18.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import "PointViewController.h"

@interface PointViewController ()

@end

@implementation PointViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
        [navigationItem setTitle:@"路径点详情"];
        [navigationBar pushNavigationItem:navigationItem animated:NO];
        [navigationItem setLeftBarButtonItem:leftButton];
        [navigationItem setRightBarButtonItem:rightButton];
        [self.view addSubview:navigationBar];
    }
    return self;
}
-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
