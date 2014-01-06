//
//  NewPositionViewController.m
//  fishFind
//
//  Created by ioschen on 13-11-11.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import "NewPositionViewController.h"
@interface NewPositionViewController ()

@end

@implementation NewPositionViewController
@synthesize bwText,djText,hbText,sjText,rqText,jlText,fwText,mcText;

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
    
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(back)];
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(addSql)];
    //设置导航栏内容
    [navigationItem setTitle:@"钓点参数设置"];
    //把导航栏集合添加入导航栏中，设置动画关闭
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    //把左右两个按钮添加入导航栏集合中
    [navigationItem setLeftBarButtonItem:leftButton];
    [navigationItem setRightBarButtonItem:rightButton];
    //把导航栏添加到视图中
    [self.view addSubview:navigationBar];
    
    [self CGRectMakeText];
    
    /*
     sqlite3_stmt      *stmt, 这个相当于ODBC的Command对象，用于保存编译好的SQL语句
     sqlite3_open(),   打开数据库，没有数据库时创建。
     sqlite3_exec(),   执行非查询的sql语句
     Sqlite3_step(), 在调用sqlite3_prepare后，使用这个函数在记录集中移动。
     Sqlite3_close(), 关闭数据库文件
     还有一系列的函数，用于从记录集字段中获取数据，如
     sqlite3_column_text(), 取text类型的数据。
     sqlite3_column_blob（），取blob类型的数据
     sqlite3_column_int(), 取int类型的数据
     */
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
//    
//    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
//        sqlite3_close(db);
//        NSLog(@"数据库打开失败");//sqlite3_open，如果数据不存在，则创建
//    }else{
//        NSLog(@"数据库打开成功");
//        [self createTable];//可以放在别的地方
//    }
    
    
    [self createData];
    [self createTable];
}
-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}

//-------------------------------
#pragma mark - 数据库
#pragma mark 创建数据库
-(void)createData
{
    //数据库宏定义的内容需要修改
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"Test.db"];
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return ;
    }
}
#pragma mark 创建表
-(void)createTable
{
    //创建一个名为User的表，有两个字段分别为string类型的Name，integer类型的 Age
    //[db executeUpdate:@"CREATE TABLE User (Name text,Age integer)"];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, beiwei TEXT, dongjing TEXT, haiba TEXT, shijian TEXT, juli TEXT, riqi TEXT, fangwei TEXT, mingcheng TEXT)"];
//    [db executeQuery:@"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, beiwei TEXT, dongjing TEXT, haiba TEXT, shijian TEXT, juli TEXT, riqi TEXT, fangwei TEXT, mingcheng TEXT)"];
    
    //还要判断是否打开数据库
    NSLog(@"创建成功");
}
#pragma mark 增
-(void)addSql
{
    //插入数据使用OC中的类型 text对应为NSString integer对应为NSNumber的整形
    //[db executeUpdate:@"INSERT INTO User (Name,Age) VALUES (?,?)",@"老婆",[NSNumber numberWithInt:20]];
    
    
    //添加
    if (mcText.text==nil) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"钓点还没有取名哦" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
        [alert show];
    }else{
        if ([db open]) {
            NSString *insertSql2=[NSString stringWithFormat:
             @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@','%@', '%@', '%@', '%@','%@', '%@', '%@')",
             TABLENAME, BEIWEI, DONGJING, HAIBA,SHIJIAN, JULI, RIQI, FANGWEI,MINGCHENG, bwText.text, djText.text, hbText.text, sjText.text, jlText.text, rqText.text, fwText.text, mcText.text];

            BOOL res2 = [db executeUpdate:insertSql2];
            if (!res2) {
                NSLog(@"error when insert db table");
            } else {
                NSLog(@"success to insert db table");
            }
            [db close];
        }
    }
}

//#pragma mark 改
//-(void)updateSql//这个好像是更新，因为得学习
//{
//    //更新数据 将“老婆”更改为“宝贝”
//    [db executeUpdate:@"UPDATE User SET Name = ? WHERE Name = ? ",@"老婆",@"宝贝"];
//    
//    
//    // 修改
//    if ([db open]) {
//        NSString *updateSql = [NSString stringWithFormat:
//                               @"UPDATE '%@' SET '%@' = '%@' WHERE '%@' = '%@'",
//                               TABLENAME,   AGE,  @"15" ,AGE,  @"13"];
//        BOOL res = [db executeUpdate:updateSql];
//        if (!res) {
//            NSLog(@"error when update db table");
//        } else {
//            NSLog(@"success to update db table");
//        }
//        [db close];
//    }
//}
//=--------------------------


//can you no
- (void)viewDidUnload
{
    [self setBwText:nil];
    [self setDjText:nil];
    [self setHbText:nil];
    [self setSjText:nil];
    [self setSjText:nil];
    [self setRqText:nil];
    [self setJlText:nil];
    [self setFwText:nil];
    [self setMcText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)getPwd
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *Name=[settings objectForKey:@"Password"];
    NSString *pwd=[settings objectForKey:@"UserName"];
    NSLog(@"Password %@",Name);
    NSLog(@"UserName %@",pwd);
    NSLog(@"读取你妹");
}
/////////////
-(void)CGRectMakeText
{
    UILabel *bw=[[UILabel alloc]initWithFrame:CGRectMake(20, 50, 80, 20)];
    bw.text=@"北纬";
    bwText=[[UITextField alloc]initWithFrame:CGRectMake(20, 80, 130, 20)];
    bwText.backgroundColor=[UIColor redColor];
    //bwText.text=[NSString stringWithFormat:@"2.2"];
    bwText.delegate=self;
    [bwText addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:bw];
    [self.view addSubview:bwText];
    UILabel *mc=[[UILabel alloc]initWithFrame:CGRectMake(180, 50, 80, 20)];
    mc.text=@"名称";
    mcText=[[UITextField alloc]initWithFrame:CGRectMake(180, 80, 130, 20)];
    mcText.backgroundColor=[UIColor redColor];
    mcText.delegate=self;
    [mcText addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mc];
    [self.view addSubview:mcText];
    
    UILabel *dj=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, 80, 20)];
    dj.text=@"东经";
    djText=[[UITextField alloc]initWithFrame:CGRectMake(20, 130, 130, 20)];
    djText.backgroundColor=[UIColor redColor];
    //djText.text=[NSString stringWithFormat:@"3.3"];
    djText.delegate=self;
    [djText addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:dj];
    [self.view addSubview:djText];
    
    UILabel *hb=[[UILabel alloc]initWithFrame:CGRectMake(20, 150, 80, 20)];
    hb.text=@"海拔高度";
    hbText=[[UITextField alloc]initWithFrame:CGRectMake(20, 180, 130, 20)];
    hbText.backgroundColor=[UIColor redColor];
    //hbText.text=[NSString stringWithFormat:@"4.12"];
    hbText.delegate=self;
    [hbText addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:hb];
    [self.view addSubview:hbText];

    UILabel *sj=[[UILabel alloc]initWithFrame:CGRectMake(20,210, 80, 20)];
    sj.text=@"时间";
    sjText=[[UITextField alloc]initWithFrame:CGRectMake(20, 240, 130, 20)];
    sjText.backgroundColor=[UIColor redColor];
    sjText.text=@"2013-11-11";
    sjText.delegate=self;
    [sjText addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:sj];
    [self.view addSubview:sjText];
    UILabel *rq=[[UILabel alloc]initWithFrame:CGRectMake(180,210, 80, 20)];
    rq.text=@"日期";
    rqText=[[UITextField alloc]initWithFrame:CGRectMake(180, 240, 130, 20)];
    rqText.backgroundColor=[UIColor redColor];
    rqText.text=@"3:20:11";
    rqText.delegate=self;
    [rqText addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:rq];
    [self.view addSubview:rqText];
    
    UILabel *jl=[[UILabel alloc]initWithFrame:CGRectMake(20, 270, 80, 20)];
    jl.text=@"距离";
    jlText=[[UITextField alloc]initWithFrame:CGRectMake(20, 300, 130, 20)];
    jlText.backgroundColor=[UIColor redColor];
    jlText.delegate=self;
    [jlText addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:jl];
    [self.view addSubview:jlText];
    UILabel *fw=[[UILabel alloc]initWithFrame:CGRectMake(180, 270, 80, 20)];
    fw.text=@"方位";
    fwText=[[UITextField alloc]initWithFrame:CGRectMake(180, 300, 130, 20)];
    fwText.backgroundColor=[UIColor redColor];
    fwText.delegate=self;
    [fwText addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:fw];
    [self.view addSubview:fwText];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)backView
{
    [self dismissModalViewControllerAnimated:YES];
}

////创建数据表
////创建一个独立的执行sql语句的方法，传入sql语句，就执行sql语句
//-(void)execSql:(NSString *)sql
//{
//    char *err;
//    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
//        sqlite3_close(db);
//        NSLog(@"数据库操作数据失败!");
//    }else{
//        NSLog(@"数据库操作数据成功!");
//    }
//}
////创建数据表PERSONINFO的语句
//-(void)createTable
//{
////    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, beiwei TEXT, age INTEGER, address TEXT, sex TEXT)";
//    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, beiwei TEXT, dongjing TEXT, haiba TEXT, shijian TEXT, juli TEXT, riqi TEXT, fangwei TEXT, mingcheng TEXT)";
//    [self execSql:sqlCreateTable];
//}
//
////插入数据
//-(void)insertData
//{
//    if (mcText.text==nil) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"钓点还没有取名哦" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
//        [alert show];
//    }else{
//        NSString *sql1 = [NSString stringWithFormat:
//                          @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@','%@', '%@', '%@', '%@','%@', '%@', '%@')",
//                          TABLENAME, BEIWEI, DONGJING, HAIBA,SHIJIAN, JULI, RIQI, FANGWEI,MINGCHENG, bwText.text, djText.text, hbText.text, sjText.text, jlText.text, rqText.text, fwText.text, mcText.text];
//        [self execSql:sql1];
//        NSLog(@"插入数据");//用alert等等提示，toast
//    }
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
