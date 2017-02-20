//
//  BirthdayDate.m
//  DatePickerTest
//
//  Created by Zhangjingshun on 11-5-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BirthdayData.h"


@implementation BirthdayData

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.year forKey:@"iYear"];
    [coder encodeInteger:self.month forKey:@"iMonth"];
    [coder encodeInteger:self.day forKey:@"iDay"];
    [coder encodeInteger:self.hour forKey:@"iHour"];
    [coder encodeInteger:self.dateType forKey:@"iDateType"];
    [coder encodeBool:self.isRunYue forKey:@"iIsRunYue"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self != nil) {
        self.year = [coder decodeIntForKey:@"iYear"];
        self.month = [coder decodeIntForKey:@"iMonth"];
        self.day	 = [coder decodeIntForKey:@"iDay"];
        self.hour = [coder decodeIntForKey:@"iHour"];
        self.dateType = [coder decodeIntForKey:@"iDateType"];
        self.isRunYue = [coder decodeBoolForKey:@"iIsRunYue"];
    }
    return self;
}

-(void)setMyBirthdayData:(NSUInteger)y m:(NSUInteger)m d:(NSUInteger)d h:(NSUInteger)h t:(NSUInteger)t r:(BOOL)r{
    self.year = y;
    self.month = m;
    self.day = d;
    self.hour = h;
    
    self.dateType = t;
    self.isRunYue = r;
}

-(void)setMyBirthdayData:(BirthdayData *)data{
    self.year = data.year;
    self.month = data.month;
    self.day = data.day;
    self.hour = data.hour;
    
    self.dateType = data.dateType;
    self.isRunYue = data.isRunYue;
}

@end



@implementation LeapMonthInfo

@end
