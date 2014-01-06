//
//  FindPathViewController.h
//  fishFind
//
//  Created by ioschen on 13-11-19.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPathViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *pathTable;
}

@end
