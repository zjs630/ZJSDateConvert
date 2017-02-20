    //
//  DateViewController.m
//  DatePickerLibrary
//
//  Created by Zhangjingshun on 11-5-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateViewController.h"
#import "DateControlView.h"

@implementation DateViewController
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super init])) {
		
		[self.view setFrame:frame];//

		dateControlView = [[DateControlView alloc] initWithFrame:[self.view bounds]];
		[self.view addSubview:dateControlView];

		UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundTaped)];
		[self.view addGestureRecognizer:tapRecognizer];
		tapRecognizer.delegate = self;
	}
    return self;
}

-(void)backGroundTaped{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PassMyBirthdayData" object:(dateControlView.birthdayData)];//目的主要将显示的日期保存。
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"JustShowBirthdayData" object:birthdayData];	//仅UI显示日期
}

//-(NSString *)getMyBirthdayData{
//	return [dateControlView getBirthdayDataInfo];
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	if (touch.view == dateControlView) {
		return YES;
	}
    return NO;
}


@end
