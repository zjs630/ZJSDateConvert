//
//  DateControl.h
//  MyPickers
//
//  Created by Zhangjingshun on 11-5-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kYearComponent 0
#define kMonthComponent 1
#define kDayComponent 2


#define startYear 1901

@class BirthdayData,DateConvert,LeapMonthInfo;

@interface DateControlView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>


@property(nonatomic,strong) BirthdayData *birthdayData;

- (void)setupDefaultDate:(BirthdayData *)birthday;  //为日期控件设置默认日期。

@end
