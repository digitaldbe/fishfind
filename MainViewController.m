//
//  MainViewController.m
//  fishFind
//
//  Created by ioschen on 13-11-1.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import "MainViewController.h"
#import "GPSNavigateViewController.h"
#import "GPSPlotterViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

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
	// Do any additional setup after loading the view.
    
    [self CGRectButton];
}
#pragma mark 画出八个图标
-(void)CGRectButton
{
    UIButton *sonarChart=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    sonarChart.frame=CGRectMake(10, 20, 100, 100);
    [self.view addSubview:sonarChart];
    
    UIButton *sonarSimulate=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    sonarSimulate.frame=CGRectMake(110, 20, 100, 100);
    [self.view addSubview:sonarSimulate];
    
    UIButton *sonarSetup=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    sonarSetup.frame=CGRectMake(210, 20, 100, 100);
    [self.view addSubview:sonarSetup];
    
    UIButton *GPSPlotter=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    GPSPlotter.frame=CGRectMake(10, 160, 100, 100);
    [GPSPlotter setTitle:@"GPSPlotter" forState:UIControlStateNormal];
    [GPSPlotter addTarget:self action:@selector(ShowGPSPlotter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:GPSPlotter];
    
    UIButton *GPSNavigate=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    GPSNavigate.frame=CGRectMake(110, 160, 100, 100);
    [GPSNavigate addTarget:self action:@selector(ShowGPSNavigate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:GPSNavigate];
    
    UIButton *GPSSetup=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    GPSSetup.frame=CGRectMake(210, 160, 100, 100);
    [self.view addSubview:GPSSetup];
    
    UIButton *SonarAndGPS=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    SonarAndGPS.frame=CGRectMake(10, 300, 100, 100);
    [SonarAndGPS addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SonarAndGPS];
}
#pragma mark 页面跳转
-(void)ShowGPSPlotter
{
    GPSPlotterViewController *t=[[GPSPlotterViewController alloc]init];
    [self presentViewController:t animated:YES completion:nil];
}
-(void)ShowGPSNavigate
{
    GPSNavigateViewController *t=[[GPSNavigateViewController alloc]init];
    [self presentViewController:t animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
