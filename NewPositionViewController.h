//
//  NewPositionViewController.h
//  fishFind
//
//  Created by ioschen on 13-11-11.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUAppDelegate.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import <sqlite3.h>
@interface NewPositionViewController : UIViewController<UITextFieldDelegate>
{
    //sqlite3* db;
    FMDatabase *db;
}
@property (nonatomic, retain) UITextField * bwText;
@property (nonatomic, retain) UITextField * djText;
@property (nonatomic, retain) UITextField * hbText;
@property (nonatomic, retain) UITextField * sjText;
@property (nonatomic, retain) UITextField * rqText;
@property (nonatomic, retain) UITextField * jlText;
@property (nonatomic, retain) UITextField * fwText;
@property (nonatomic, retain) UITextField * mcText;

@end
