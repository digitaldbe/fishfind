//
//  FindPositionViewController.m
//  fishFind
//
//  Created by ioschen on 13-11-12.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import "FindPositionViewController.h"

@interface FindPositionViewController ()

@end

@implementation FindPositionViewController
@synthesize sqlQueryTypetext;
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
    [self CGRectMakeNavigationBar];
    [self CGRectMakeButton];
    pointArray=[[NSMutableArray alloc]init];
    
    //双击钓点名称进入钓点详情界面(tableview里的钓点)
    
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
    [self selectSql];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
//    
//    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
//        sqlite3_close(db);
//        NSLog(@"数据库打开失败");//sqlite3_open，如果数据不存在，则创建
//    }
//    
//    [self selectData];
}
-(void)CGRectMakeNavigationBar
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"GPS参数设置"];
    //把导航栏集合添加入导航栏中，设置动画关闭
    [navigationBar pushNavigationItem:navigationItem animated:NO];

    [self.view addSubview:navigationBar];
}

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
    [delbutton addTarget:self action:@selector(deleteSql) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delbutton];
    
    UIButton *mapbutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    mapbutton.frame=CGRectMake(160, self.view.frame.size.height-40, 80, 40);
    [mapbutton setTitle:@"地图" forState:UIControlStateNormal];
    [mapbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapbutton];
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    backbutton.frame=CGRectMake(240, self.view.frame.size.height-40, 80, 40);
    [backbutton setTitle:@"返回" forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
}
#pragma mark 删
-(void)deleteSql
{
    //删除数据
    //[db executeUpdate:@"DELETE FROM User WHERE Name = ?",@"老婆"];

    // 删除
    if ([db open]) {
        //NSUserDefaults * settings=[NSUserDefaults standardUserDefaults];
        //NSString *key=[settings objectForKey:@"selectRow"];
        
        
//        if (key==nil) {//判断不对，这个只能第一次安装可，是否清空,no
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"你还没有选中钓点哦" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
//            [alert show];
//        }else{
//            NSString *sssss=@"男";
//            char *err;
//            NSString *sql =[NSString stringWithFormat:@"DELETE from FAVORITE_TABLE WHERE MINGCHENG = %@",sssss];
//            
//            NSLog(@"sql  %@",sql);
//            if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
//                sqlite3_close(db);
//                NSLog(@"数据库操作数据失败!");
//            }else{
//                NSLog(@"数据库操作数据成功!");
//            }
//        }
        //NSString *sql =[NSString stringWithFormat:@"DELETE from FAVORITE_TABLE WHERE MINGCHENG = %@",sssss];
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@ = '%@'",
                               TABLENAME, MINGCHENG, @"方法"];
        BOOL res = [db executeUpdate:deleteSql];
        if (!res) {
            NSLog(@"error when delete db table");
        } else {
            NSLog(@"success to delete db table");
            //在selectsql开始判断，直接清空数组，重新添加，就不需要在这里刷新呢
            //[pointArray removeObject:@"方法"];//不是这一个，需要麻烦一点
            [self selectSql];//删除玩查询刷新
        }
        [db close];
    }else{
        NSLog(@"删除失败");
    }
}
//-(void)delltePoint
//{
//    NSUserDefaults * settings=[NSUserDefaults standardUserDefaults];
//    NSString *key=[settings objectForKey:@"selectRow"];
//    if (key==nil) {//判断不对，这个只能第一次安装可，是否清空,no
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"你还没有选中钓点哦" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
//        [alert show];
//    }else{
//        NSString *sssss=@"男";
//        char *err;
//        NSString *sql =[NSString stringWithFormat:@"DELETE from FAVORITE_TABLE WHERE MINGCHENG = %@",sssss];
//        
//        NSLog(@"sql  %@",sql);
//        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
//            sqlite3_close(db);
//            NSLog(@"数据库操作数据失败!");
//        }else{
//            NSLog(@"数据库操作数据成功!");
//        }
//    }
//}
-(void)backView
{
    [self dismissModalViewControllerAnimated:YES];
}
//NSString *mystring = @"Letter1234";
//NSString *regex = @"[a-z][A-Z][0-9]";
//
//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//
//if ([predicate evaluateWithObject:mystring] == YES) {
//    //implement
//}
//
//
//NSString *regex = @"*[a-z][A-Z][0-9]*";
//  NSString *regex = @".*[a-z][A-Z][0-9].*";
//
//NSString *mystring = [NSString stringWithString:@"Letter1234"];
//NSCharacterSet *disallowedCharacters = [[NSCharacterSet
//                                         characterSetWithCharactersInString:@"0123456789QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm "] invertedSet];
//NSRange foundRange = [mystring rangeOfCharacterFromSet:disallowedCharacters];
//if (foundRange.location != NSNotFound) {
//    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle: @"" message: @"Letters and numbers only"
//                                                     delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
//}
//这样子判断
//
//NSString *ptr = @"^[A-Za-z]+[0-9]+[A-Za-z0-9]*|[0-9]+[A-Za-z]+[A-Za-z0-9]*$";



//---------------------------------

#pragma mark 查
-(void)selectSql
{
    NSLog(@"数据库操作数据!");//语句也可以大小写，数据库有很多方法。比如只查询10句等等
    //返回数据库中第一条满足条件的结果
    //NSString *aa=[db stringForQuery:@"SELECT Name FROM User WHERE Age = ?",@"20"];
    //NSLog(@"%@",aa);
    
    //     //这样我们就查询返回了一条数据，那当我们想要查询放返回多条数据怎么办呢？不用愁，之前我就提到了FMDB中的另外一个主要的类，FMResultSet，这是一个结果集！返回多条数据时FMDB会将数据放在这个结果集中，然后我们在对这个结果集进行查询操作！很简单
    //     FMResultSet *rs=[db executeQuery:@"SELECT * FROM User"];
    //     rs=[db executeQuery:@"SELECT * FROM User WHERE Age = ?",@"20"];
    //     while ([rs next]){
    //         NSLog(@"%@ %@",[rs stringForColumn:@"Name"],[rs stringForColumn:@"Age"]);
    //     }
    
    
    
    //数据库查询操作：
    //查询操作使用了executeQuery，并涉及到FMResultSet。
    if ([db open]) {
        [pointArray removeAllObjects];//需要判断，最好//在哪都一样啊
        
        //FMDB提供如下多个方法来获取不同类型的数据：
        //    intForColumn:
        //    longForColumn:
        //    longLongIntForColumn:
        //    boolForColumn:
        //    doubleForColumn:
        //    stringForColumn:
        //    dateForColumn:
        //    dataForColumn:
        //    dataNoCopyForColumn:
        //    UTF8StringForColumnIndex:
        //    objectForColumn:
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",TABLENAME];
        //@"SELECT * FROM PERSONINFO ORDER BY MINGCHENG";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            //时间这些格式重新写
            //int Id = [rs intForColumn:ID];
            NSString * beiwei = [rs stringForColumn:BEIWEI];
            NSString * dongjing = [rs stringForColumn:DONGJING];
            NSString * haiba = [rs stringForColumn:HAIBA];
            NSString * shijian = [rs stringForColumn:SHIJIAN];
            NSString * juli = [rs stringForColumn:JULI];
            NSString * riqi = [rs stringForColumn:RIQI];
            NSString * fangwei = [rs stringForColumn:FANGWEI];
            NSString * mingcheng = [rs stringForColumn:MINGCHENG];
            NSLog(@"名称:%@  经度:%@  纬度:%@  海拔:%@ 其余%@  %@  %@ %@",mingcheng,dongjing, beiwei,haiba,shijian,juli,riqi,fangwei);
            [pointArray addObject:mingcheng];//把钓点详细信息放在另外数组里面或者什么的
            [self CreateTable];
        }
        [db close];
    }
}
////查询数据库并打印数据
//-(void)selectData
//{
// 
//    NSLog(@"数据库操作数据!");//语句也可以大小写，数据库有很多方法。比如只查询10句等等
//    if ([sqlQueryTypetext.text isEqualToString:@"typeName"]) {
//        sqlQuery=@"SELECT * FROM PERSONINFO ORDER BY MINGCHENG";
//    }else if ([sqlQueryTypetext.text isEqualToString:@"typeJuli"]){
//        sqlQuery=@"SELECT * FROM PERSONINFO ORDER BY SHIJIAN";
//    }else if ([sqlQueryTypetext.text isEqualToString:@"typeTime"]){
//        sqlQuery=@"SELECT * FROM PERSONINFO ORDER BY MINGCHENG";
//    }else{//其实这句话没有必要
//        //默认全部执行这句话，这个还需要修改判断
//        sqlQuery=@"SELECT * FROM PERSONINFO ORDER BY MINGCHENG";
//    }
//    //NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
//    sqlite3_stmt * statement;
//    
//    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            char *beiwei = (char*)sqlite3_column_text(statement, 1);
//            NSString *nsbeiweiStr = [[NSString alloc]initWithUTF8String:beiwei];
//            
//            char *dongjing = (char*)sqlite3_column_text(statement, 2);
//            NSString *nsdongjingStr = [[NSString alloc]initWithUTF8String:dongjing];
//            
//            char *haiba = (char*)sqlite3_column_text(statement, 3);
//            NSString *nshaibaStr = [[NSString alloc]initWithUTF8String:haiba];
//            
//            char *shijian = (char*)sqlite3_column_text(statement, 4);
//            NSString *nsshijianStr = [[NSString alloc]initWithUTF8String:shijian];
//            
//            char *juli = (char*)sqlite3_column_text(statement, 5);
//            NSString *nsjuliStr = [[NSString alloc]initWithUTF8String:juli];
//            
//            char *riqi = (char*)sqlite3_column_text(statement, 6);
//            NSString *nsriqiStr = [[NSString alloc]initWithUTF8String:riqi];
//            
//            char *fangwei = (char*)sqlite3_column_text(statement, 7);
//            NSString *nsfangweiStr = [[NSString alloc]initWithUTF8String:fangwei];
//            
//            char *mingcheng = (char*)sqlite3_column_text(statement, 8);
//            NSString *nsmingchengStr = [[NSString alloc]initWithUTF8String:mingcheng];
//            //int age = sqlite3_column_int(statement, 2);//如果是int类型就直接，不需要转换
//            NSLog(@"名称:%@  经度:%@  纬度:%@  海拔:%@ 其余%@  %@  %@ %@",nsmingchengStr,nsbeiweiStr, nsdongjingStr,nshaibaStr,nsshijianStr,nsjuliStr,nsriqiStr,nsfangweiStr);
//            [pointArray addObject:nsmingchengStr];//把钓点详细信息放在另外数组里面或者什么的
//        }
//    }
//    sqlite3_close(db);
//    [self CreateTable];
//}
-(void)CreateTable
{
    pointTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-88) style:UITableViewStylePlain];
    pointTable.dataSource=self;
    pointTable.delegate=self;
    pointTable.backgroundColor=[UIColor redColor];
    [self.view addSubview:pointTable];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pointArray count];
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
    
    cell.textLabel.text=[pointArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark 记录点击了第几个，简称选中了第几个
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectRow=[NSString stringWithFormat:@"%d",indexPath.row];
    NSUserDefaults * settings=[NSUserDefaults standardUserDefaults];
    [settings setObject:selectRow forKey:@"selectRow"];
    NSLog(@"%@",[settings objectForKey:@"selectRow"]);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
