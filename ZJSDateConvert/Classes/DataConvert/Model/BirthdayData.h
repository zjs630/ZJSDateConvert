//
//  BirthdayDate.h
//  DatePickerTest
//
//  Created by Zhangjingshun on 11-5-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger,DateType) {
    kGongLi, //公历
    kNongLi, //农历
    kOther,
};

@interface BirthdayData : NSObject <NSCoding>

@property(nonatomic, assign) NSUInteger year;
@property(nonatomic, assign) NSUInteger month;
@property(nonatomic, assign) NSUInteger day;
@property(nonatomic, assign) NSUInteger hour;
@property(nonatomic, assign) DateType dateType;
@property(nonatomic, assign) BOOL isRunYue; //是否闰月

-(void)setMyBirthdayData:(BirthdayData *)data;

-(void)setMyBirthdayData:(NSUInteger)y m:(NSUInteger)m d:(NSUInteger)d h:(NSUInteger)h t:(NSUInteger)t r:(BOOL)r;

@end


@interface LeapMonthInfo : NSObject

@property(nonatomic) BOOL hasLeapMonth;             //是否闰月
@property(nonatomic) BOOL isBig;                    //闰几月
@property(nonatomic) NSUInteger leapMonthNumber;    //闰大月或小月，1大，0小

@end
