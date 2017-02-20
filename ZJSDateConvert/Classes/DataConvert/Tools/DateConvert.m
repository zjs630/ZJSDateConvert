//
//  DateConvert.m
//  DatePickerTest
//
//  Created by Zhangjingshun on 11-5-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateConvert.h"
#import"BirthdayData.h"

@implementation DateConvert

-(BirthdayData *)Convert2GongLi:(BirthdayData *)nongLiDate{
    
    NSUInteger year =nongLiDate.year;
    NSUInteger month = nongLiDate.month;
    NSUInteger day = nongLiDate.day;
    //计算农历年份到公历1900年1月1日的天数。//yearDays
    NSUInteger nongLiyearDays = 0, nongLiMonthDays = 0, yearDays = 0;
    for (NSUInteger i=year-1; i>=1900; i--) {
        NSUInteger temp = 0;
        temp = [self nongLiYearDays:i];
        nongLiyearDays += temp;
    }
    
    LeapMonthInfo *myLeapMonthInfo = [self ReturnLeapMonthInfo:year];
    for (NSUInteger i = 1; i<month; i++) {
        nongLiMonthDays +=[self monthDays:i year:(year-1900)];
    }
    if (myLeapMonthInfo.hasLeapMonth) {
        NSUInteger temp2 = myLeapMonthInfo.leapMonthNumber;
        if ((month == temp2) && nongLiDate.isRunYue) {
            nongLiMonthDays +=[self monthDays:month year:(year-1900)];
        }
        if (month>temp2) {
            myLeapMonthInfo.isBig?(nongLiMonthDays+=30):(nongLiMonthDays+=29);
        }
    }
    
    
    yearDays = nongLiyearDays + nongLiMonthDays + day + 30;
    
    //求年(iYear)
    NSUInteger gongLiYearDaysCount = 0;
    NSUInteger resultYear = 0;
    for (NSUInteger iYear = 1900; iYear <= year; iYear++) {
        NSUInteger temp =0;
        if ([self isLeapYear:iYear]) {//这一年是否闰年
            temp = 366;
        }
        else {
            temp = 365;
        }
        gongLiYearDaysCount += temp;
        if (gongLiYearDaysCount>=yearDays) {
            gongLiYearDaysCount -=temp;
            resultYear = iYear;
            break;
        }
    }
    nongLiDate.year = resultYear;
    
    //求月份 m月
    NSUInteger monthDays = yearDays - gongLiYearDaysCount;
    NSUInteger resultMonth = 1,d = 0;
    if ([self isLeapYear:year]) {//这一年是否闰年
        for (NSUInteger m = 1; m<=12; m++) {
            if (solarMonthCount2[m] >= monthDays) {
                //求天
                d = monthDays - solarMonthCount2[m-1];
                resultMonth = m;
                break;
            }
        }
    }
    else {
        for (NSUInteger m = 1; m<=12; m++) {
            if (solarMonthCount[m] >= monthDays) {
                //求天
                d = monthDays - solarMonthCount[m-1];
                resultMonth = m;
                break;
            }
        }
    }
    
    nongLiDate.month = resultMonth;
    nongLiDate.day = d;
    nongLiDate.dateType = kGongLi;
    nongLiDate.isRunYue = NO;
    return nongLiDate;
}

-(BirthdayData *)Convert2NongLi:(BirthdayData *)gongLiDate{
    NSUInteger year =gongLiDate.year;
    NSUInteger month = gongLiDate.month;
    NSUInteger day = gongLiDate.day;
    //计算年份到农历1900年1月1日的天数。
    NSUInteger leapDays = 0;
    for (NSUInteger i=year-1; i>=1900; i--) {
        if ([self isLeapYear:i]) {
            leapDays++;
        }
        
    }
    if ([self isLeapYear:year] && month>2) {
        leapDays++;
    }
    
    NSUInteger yearDays = (year-1900)*365+solarMonthCount[month-1]+leapDays+day-30;//29189
    
    //求年(y+1900)
    NSUInteger nongLiYearDaysCount = 0, y = 0;//year_Info[y]
    for (NSUInteger iYear = 1900; iYear <= year+1; iYear++) {
        NSUInteger temp =0;
        temp= [self nongLiYearDays:iYear];
        nongLiYearDaysCount += temp;
        if (nongLiYearDaysCount<yearDays) {
            y += 1;
        }
        else {
            nongLiYearDaysCount -=temp;
            break;
        }
        
    }
    
    //求月份 m月
    NSUInteger monthDays = yearDays - nongLiYearDaysCount;//
    NSUInteger nongLiMonthDaysCount = 0, m = 1;
    LeapMonthInfo *leapMonthInfo = [self ReturnLeapMonthInfo:y+1900];
    
    gongLiDate.isRunYue = NO;
    NSUInteger k = leapMonthInfo.leapMonthNumber+1;
    for (NSUInteger n=1; n<=12; n++) {
        if ((leapMonthInfo.hasLeapMonth) && (m == k)) {
            leapMonthInfo.isBig?(nongLiMonthDaysCount+=30):(nongLiMonthDaysCount+=29);
            if(nongLiMonthDaysCount > monthDays){
                gongLiDate.isRunYue = YES;
                m--;
                leapMonthInfo.isBig?(nongLiMonthDaysCount-=30):(nongLiMonthDaysCount-=29);
                break;
            }
            else {
                gongLiDate.isRunYue = NO;
                k = -1;
                --n;
            }
        }
        else {
            NSUInteger temp2 = [self monthDays:n year:y];
            nongLiMonthDaysCount += temp2;
            if (nongLiMonthDaysCount < monthDays) {
                m ++;
            }
            else {
                nongLiMonthDaysCount -= temp2;
                break;
            }
            
        }
        
    }
    //求天
    NSUInteger d = monthDays - nongLiMonthDaysCount;
    gongLiDate.year = y+1900;
    gongLiDate.month = m;
    gongLiDate.day = d;
    gongLiDate.dateType = kNongLi;
    
    return gongLiDate;
}

#pragma mark -
#pragma mark 农历
-(LeapMonthInfo *)ReturnLeapMonthInfo:(NSUInteger)year{
    LeapMonthInfo *oneYearInfo = [[LeapMonthInfo alloc] init];
    NSUInteger i = year-1900;
    NSUInteger lastNum = year_Info[i]&0xf;
    if(lastNum == 0){//有无闰月
        oneYearInfo.hasLeapMonth = NO;
    }
    else {
        oneYearInfo.hasLeapMonth = YES;
        oneYearInfo.leapMonthNumber = lastNum;
        NSUInteger firstNum = year_Info[i]&0xf0000;
        if (firstNum == 0) {//闰大小月
            //NSLog(@"闰小月");
            oneYearInfo.isBig = NO;
        }
        else {
            //NSLog(@"闰大月");
            oneYearInfo.isBig = YES;
        }
    }
    return oneYearInfo;
}

-(BOOL)BigOrSmallMonth:(NSUInteger)month Year:(NSUInteger)year {
    //int i = year-1900;
    //	int monthInfo = year_Info[i]&0x0fff0;
    //	int a = monthInfo>>(16-month)&0x1;
    if (year_Info[year-1900]&(0x10000>>month)) {
        //NSLog(@"农历%d月是大月",month);
        return YES;
    }
    return NO;
}

//====================================== 返回农历 y年的总天数
-(NSUInteger)nongLiYearDays:(NSUInteger)year{
    NSUInteger i, sum = 348;
    for(i=0x8000; i>0x8; i>>=1){
        sum += (year_Info[year-1900] & i)? 1: 0;
    }
    //sum +=
    NSUInteger temp = [self leapDays:year];
    sum +=temp;
    return sum;
}

//====================================== 返回农历 y年闰月的天数
-(NSUInteger)leapDays:(NSUInteger)y{
    NSUInteger i = y-1900;
    if(year_Info[i] & 0xf){//返回农历 y年闰哪个月 1-12 , 没闰返回 0
        if (year_Info[i] & 0x10000) {
            return 30;
        }
        else {
            return 29;
        }
        
        //return((year_Info[y-1900] & 0x10000)? 30: 29);
    }
    return 0;
}

//====================================== 返回农历 y年m月的总天数
-(NSUInteger)monthDays:(NSUInteger)month year:(NSUInteger)y{
    return( (year_Info[y] & (0x10000>>month))? 30: 29 );
}

#pragma mark -
#pragma mark 公历

//==============================返回公历 y年是否是闰年
-(BOOL)isLeapYear:(NSUInteger)year{
    return (((year%4 == 0) && (year%100 != 0)) || year%400 == 0);
}

//==============================返回公历 y年某m月的天数
-(NSUInteger)solarDays:(NSUInteger)y month:(NSUInteger)m{
    if(m==2)
        return((((y%4 == 0) && (y%100 != 0)) || (y%400 == 0))? 29: 28);
    else
        return(solarMonth[m-1]);
}


@end
