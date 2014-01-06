//
//  NewPathViewController.h
//  fishFind
//
//  Created by ioschen on 13-11-13.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPathViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *nameText;
    UITextField *maxText;
    UITextField *meiText;
}
@property (nonatomic, retain) UILabel *danweiLable;

@end
