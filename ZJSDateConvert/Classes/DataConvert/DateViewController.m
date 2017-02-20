    //
//  DateViewController.m
//  DatePickerLibrary
//
//  Created by Zhangjingshun on 11-5-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateViewController.h"
#import "DateControlView.h"
@interface DateViewController()

@property(nonatomic,strong) DateControlView *dateControlView;


@end
@implementation DateViewController
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super init])) {
		
		[self.view setFrame:frame];//

		_dateControlView = [[DateControlView alloc] initWithFrame:[self.view bounds]];
		[self.view addSubview:_dateControlView];

		UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundTaped)];
		[self.view addGestureRecognizer:tapRecognizer];
		tapRecognizer.delegate = self;
	}
    return self;
}

-(void)backGroundTaped{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PassMyBirthdayData" object:(_dateControlView.birthdayData)];//目的主要将显示的日期保存。
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"JustShowBirthdayData" object:birthdayData];	//仅UI显示日期
}

/**
 为日期控件设置默认日期。
 @param birthday 年月日，传nil，默认为当前日期
 */
- (void)setupDefaultDate:(BirthdayData *)birthday{
    [_dateControlView setupDefaultDate:birthday];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	if (touch.view == _dateControlView) {
		return YES;
	}
    return NO;
}


@end
