//
//  FindPathViewController.m
//  fishFind
//
//  Created by ioschen on 13-11-19.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import "FindPathViewController.h"
#import "PathViewController.h"
@interface FindPathViewController ()

@end

@implementation FindPathViewController

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
    [self CGRectMakeTable];
    [self CGRectMakeButton];
}

-(void)CGRectMakeTable
{
    pathTable=[[UITableView alloc]initWithFrame:CGRectMake(40, 48, 100, 100) style:UITableViewStylePlain];
    pathTable.delegate=self;
    pathTable.dataSource=self;
    [self.view addSubview:pathTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    
    cell.textLabel.text=@"df";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.row==1) {
        PathViewController *pathView=[[PathViewController alloc]init];
        [self presentModalViewController:pathView animated:YES];
    //}
    NSLog(@"test");
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
    [mapbutton setTitle:@"去起点" forState:UIControlStateNormal];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
