//
//  FindPositionViewController.h
//  fishFind
//
//  Created by ioschen on 13-11-12.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YUAppDelegate.h"
#import "FMDatabase.h"
#import <sqlite3.h>
@interface FindPositionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    //sqlite3* db;
    FMDatabase *db;
    
    UITableView* pointTable;
    NSMutableArray* pointArray;
    NSString * sqlQuery;//执行的数据库查询语句
}

@property (nonatomic, retain) UITextField *sqlQueryTypetext;

@end
