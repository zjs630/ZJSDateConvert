//
//  LeapMonthInfo.h
//  DatePickerTest
//
//  Created by Zhangjingshun on 11-5-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LeapMonthInfo : NSObject

@property(nonatomic) BOOL hasLeapMonth;     //是否闰月
@property(nonatomic) BOOL isBig;            //闰几月
@property(nonatomic) NSUInteger leapMonthNumber;   //闰大月或小月，1大，0小

@end
