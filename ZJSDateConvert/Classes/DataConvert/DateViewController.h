//
//  DateViewController.h
//  DatePickerLibrary
//
//  Created by Zhangjingshun on 11-5-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//使用方法：
/*
1，导入头文件
#import "BirthdayData.h"
#import "DateViewController.h"
 
2，添加通知
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOneBirthdayData:) name:@"SaveDataAndCloseView" object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(justShowBirthdayData:) name:@"JustShowBirthdayData" object:nil];
 
 3，显示日期控件。
dateViewController = [[DateViewController alloc] initWithFrame:CGRectMake(0,44, 320, 460)];
 [dateViewController setupDefaultDate:nil]; //一定要设置时间。//参数为空，显示当前时间。
[self.view addSubview:dateViewController.view];
 
 4，实现通知方法。
 -(void)setOneBirthdayData:(NSNotification *)notifi{
 BirthdayData *tempData = (BirthdayData *)[notifi object];
 //......进行日期本地存储。
 }
 
 -(void)justShowBirthdayData:(NSNotification *)notifi{
 BirthdayData *tempData = (BirthdayData *)[notifi object];
 NSString *temp2 = [self oneBirthdayString:tempData];
 dateTextField.text = temp2;
 }
 
//日期转换应该没问题，UI可根据需求自己更改。
*/

#import <UIKit/UIKit.h>

@class DateControlView,BirthdayData;
@interface DateViewController : UIViewController<UIGestureRecognizerDelegate>

- (id)initWithFrame:(CGRect)frame;
-(void)backGroundTaped;

//-(NSString *)getMyBirthdayData;
//-(void)setMyBirthdayData:(BirthdayData *)birthdayData;
- (void)setupDefaultDate:(BirthdayData *)birthday;  //为日期控件设置默认日期。
@end
