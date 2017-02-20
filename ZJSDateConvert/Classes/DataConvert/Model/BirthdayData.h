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

@property(nonatomic) NSUInteger year;
@property(nonatomic) NSUInteger month;
@property(nonatomic) NSUInteger day;
@property(nonatomic) NSUInteger hour;
@property(nonatomic) DateType dateType;
@property(nonatomic) BOOL isRunYue; //是否闰月

-(void)setMyBirthdayData:(BirthdayData *)data;
-(void)setMyBirthdayData:(NSUInteger)y m:(NSUInteger)m d:(NSUInteger)d h:(NSUInteger)h t:(NSUInteger)t r:(BOOL)r;

@end
