//
//  DateControl.m
//  MyPickers
//
//  Created by Zhangjingshun on 11-5-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateControlView.h"

#import "BirthdayData.h"
#import "LeapMonthInfo.h"
#import "DateConvert.h"

@interface DateControlView()
@property (nonatomic,strong) UIPickerView *myPickView;
@property (nonatomic,strong) UIButton *isLeapMonthButton;
@property (nonatomic,strong) UIImageView *selectedLeapMonth;

@property (nonatomic,strong) UISegmentedControl *segmentedCtrl;

@property (nonatomic,strong) DateConvert *dateConvert;

@property (nonatomic,assign) NSUInteger dayCount;   //日历控件依据月份，要显示的天数

@end

@implementation DateControlView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		//创建UIPickerView对象
        _myPickView = [[UIPickerView alloc] init];
		_myPickView.frame = CGRectMake(0, frame.size.height-180-39, frame.size.width,180);
		_myPickView.delegate = self;
		_myPickView.dataSource = self;
		_myPickView.backgroundColor = [UIColor whiteColor];
		_myPickView.showsSelectionIndicator = YES;
		[self addSubview:_myPickView];
		
		//datePicker上部背景
		UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-180-39-35, frame.size.width, 39)];
		[bgView setUserInteractionEnabled:NO];
		bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"datePicker_bg.png"]];
		[self addSubview:bgView];
		
		NSArray *textOptionsArray = [NSArray arrayWithObjects:@"公历",@"农历", nil];
		_segmentedCtrl = [[UISegmentedControl alloc] initWithItems:textOptionsArray];
		_segmentedCtrl.frame = CGRectMake(20.0, frame.size.height-180-39-32, 120, 32);
		_segmentedCtrl.selectedSegmentIndex = 0;
		[_segmentedCtrl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_segmentedCtrl];

        
		//create three buttons
		_isLeapMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_isLeapMonthButton.frame = CGRectMake(154, frame.size.height-180-39-32, 100, 32);
		//[isLeapMonthButton setBackgroundColor:[UIColor redColor]];
		//[isLeapMonthButton setTitle:@"是否闰月" forState:UIControlStateNormal];
		//[isLeapMonthButton setBackgroundImage:[UIImage imageNamed:@"button_isLeapMonth.png"] forState:UIControlStateNormal];
		[_isLeapMonthButton addTarget:self action:@selector(isLeapMonthButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_isLeapMonthButton];
		_isLeapMonthButton.hidden = YES;
		
		//one pic
		UIImageView *oneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 22, 22)];
		oneImageView.image = [UIImage imageNamed:@"button_isLeapMonth.png"];
		[_isLeapMonthButton addSubview:oneImageView];
		//selectedLeapMonth.hidden = YES;
		
		//选中闰月的对钩
		_selectedLeapMonth = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 22, 22)];
		_selectedLeapMonth.image = [UIImage imageNamed:@"checked.png"];
		[_isLeapMonthButton addSubview:_selectedLeapMonth];
		_selectedLeapMonth.hidden = YES;
		
		//“闰月”两个文字
		UILabel *leapMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 5, 40, 22)];
		leapMonthLabel.text = @"闰月";
		[leapMonthLabel setBackgroundColor:[UIColor clearColor]];
		[_isLeapMonthButton addSubview:leapMonthLabel];
		
		//创建BirthdayData和LeapMonthInfo数据对象
		_birthdayData = [[BirthdayData alloc] init];
		_leapMonthInfo = [[LeapMonthInfo alloc] init];
		
		_dateConvert = [[DateConvert alloc] init];
    }
    return self;
}
- (void)setupDefaultDate:(BirthdayData *)birthday{//未指定BirthdayData数据，初始化为当前时间。
	//获取当前日期和时间
    NSDate *dt = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd/H"];
    //输出为文本格式
    NSString *str = [formatter stringFromDate:dt];
    NSArray *myDate = [str componentsSeparatedByString:@"/"];
    
    if (birthday == nil) {
		[_birthdayData setMyBirthdayData:[[myDate objectAtIndex:0] intValue]m:[[myDate objectAtIndex:1] intValue] d:[[myDate objectAtIndex:2] intValue] h:[[myDate objectAtIndex:3] intValue] t:kGongLi r:NO];
	}
	else {
		[_birthdayData setMyBirthdayData:birthday];
	}
	
	if (_birthdayData.dateType == kNongLi) {
		self.leapMonthInfo = [_dateConvert ReturnLeapMonthInfo:_birthdayData.year];
		[self hiddenOrShowLeapMonthButton];
		//更新天的数据
		if ([_dateConvert BigOrSmallMonth:_birthdayData.month Year:_birthdayData.year]) {
			_dayCount = 30;
		}
		else {
			_dayCount = 29;
		}
	}
	else if(_birthdayData.dateType == kGongLi){
		//更新天的数据
		_dayCount = [_dateConvert solarDays:_birthdayData.year month:_birthdayData.month];
	}

	
	[_myPickView selectRow:_birthdayData.year-startYear inComponent:0 animated:NO];//x年
	[_myPickView selectRow:_birthdayData.month-1 inComponent:1 animated:NO];//x月
	[_myPickView reloadComponent:kDayComponent];
	[_myPickView selectRow:_birthdayData.day-1 inComponent:2 animated:NO];//x日
}

-(void)segmentChanged:(id)sender{
	if ([(UISegmentedControl *)sender selectedSegmentIndex]==0) { //通过判断点击的是UISegmentedControl中的哪个按钮。
		[self gongLiButtonPressed];
	}
	else {
		[self nongLiButtonPressed];
	}
}

-(void)gongLiButtonPressed{

    if (_birthdayData.dateType == kGongLi) {
		return;
	}
	if (_birthdayData.year == 2049) {
		if (_birthdayData.month == 12 && _birthdayData.day >7) {
            //FIXME:提示信息
            NSLog(@"提示:日期转换超出转换范围！");
			return;
		}
	}
	self.birthdayData = [_dateConvert Convert2GongLi:_birthdayData];

    [_myPickView selectRow:_birthdayData.year-startYear inComponent:0 animated:NO];//年
	[_myPickView selectRow:_birthdayData.month-1 inComponent:1 animated:NO];//月
	
	_dayCount = [_dateConvert solarDays:_birthdayData.year month:_birthdayData.month];
	[_myPickView reloadComponent:kDayComponent];
	
	
	[_myPickView selectRow:_birthdayData.day-1 inComponent:2 animated:NO];//日
	
	_isLeapMonthButton.hidden = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"JustShowBirthdayData" object:_birthdayData];	
}

-(void)nongLiButtonPressed{
	if (_birthdayData.dateType == kNongLi) {
		return;
	}
	if (_birthdayData.year == 1901) {
		if (_birthdayData.month == 1 || (_birthdayData.month == 2 && _birthdayData.day < 19)){
            //FIXME:提示信息
            NSLog(@"提示:日期转换超出转换范围！");
			return;
		}
	}
	self.birthdayData = [_dateConvert Convert2NongLi:_birthdayData];

    [_myPickView selectRow:_birthdayData.year-startYear inComponent:0 animated:NO];//年
	[_myPickView selectRow:_birthdayData.month-1 inComponent:1 animated:NO];//月
	[_myPickView selectRow:_birthdayData.day-1 inComponent:2 animated:NO];//日

	self.leapMonthInfo = [_dateConvert ReturnLeapMonthInfo:_birthdayData.year];
	[self hiddenOrShowLeapMonthButton];
	
	//更新天数据
	[self updateNongLiDay:[_dateConvert BigOrSmallMonth:_birthdayData.month Year:_birthdayData.year]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"JustShowBirthdayData" object:_birthdayData];
}

-(void)hiddenOrShowLeapMonthButton{
	
	if (_leapMonthInfo.hasLeapMonth && (_leapMonthInfo.leapMonthNumber == _birthdayData.month)) {
		_isLeapMonthButton.hidden = NO;
		//闰月是否选中
		if (_birthdayData.isRunYue) {
			_selectedLeapMonth.hidden = NO;
		}
		else {
			_selectedLeapMonth.hidden = YES;
		}

	}
	else {
		_isLeapMonthButton.hidden = YES;
		_birthdayData.isRunYue =NO;
	}
}
-(void)isLeapMonthButtonPressed{
	if (_birthdayData.isRunYue == NO) {
		_birthdayData.isRunYue = YES;
		_selectedLeapMonth.hidden = NO;
	}
	else {
		_birthdayData.isRunYue = NO;
		_selectedLeapMonth.hidden = YES;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"JustShowBirthdayData" object:_birthdayData];
}

#pragma mark -
#pragma mark Picker Private Methods


-(void)updateNongLiDay:(BOOL)isBig{
	if (isBig) {
		_dayCount = 30;
	}
	else {
		_dayCount = 29;
	}
	[_myPickView reloadComponent:kDayComponent];
	_birthdayData.day = [_myPickView selectedRowInComponent:kDayComponent]+1;
	
}

-(void)updateGongLiDay{
	NSUInteger selectedMonth = [_myPickView selectedRowInComponent:kMonthComponent]+1;
	_dayCount = [_dateConvert solarDays:_birthdayData.year month:selectedMonth];
	[_myPickView reloadComponent:kDayComponent];
	_birthdayData.day = [_myPickView selectedRowInComponent:kDayComponent]+1;
}

#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == kYearComponent) {
        NSInteger count = 2049 - startYear + 1;
		return count;
	}
	else if(component == kMonthComponent){
		return 12;
	}
	else if(component == kDayComponent){
		return _dayCount;
	}
	return 0;
}
#pragma mark Picker Delegate Methods

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[UIFont systemFontOfSize:20.0]];
	NSString *tempString = nil;
	switch (component) {
		case kYearComponent:
			tempString = [NSString stringWithFormat:@"%ld",row+startYear];
			break;
		case kMonthComponent:
			tempString = [NSString stringWithFormat:@"%ld",row+1];
			break;
		case kDayComponent:
			tempString = [NSString stringWithFormat:@"%ld",row+1];
			break;
		default:
			break;
	}
	[label setText:tempString];
//	[label setUserInteractionEnabled:NO];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	switch (component) {
		case kYearComponent:{
			NSUInteger selectedYear = row+startYear;
			_birthdayData.year = selectedYear;
			//NSLog(@"选择了%d年",birthdayData.year);
			//判断选择年的这个月有多少天。更新天的数据
			NSUInteger selectedMonth = [pickerView selectedRowInComponent:kMonthComponent]+1;//选中的是几月。
			if (_birthdayData.dateType == kNongLi) {
				//处理闰月的情况
				self.leapMonthInfo = [_dateConvert ReturnLeapMonthInfo:selectedYear];
				[self hiddenOrShowLeapMonthButton];
				//更新天的数据
				[self updateNongLiDay:[_dateConvert BigOrSmallMonth:selectedMonth Year:selectedYear]];
			}
			else {
				[self updateGongLiDay];
			}
			
			_birthdayData.month = [pickerView selectedRowInComponent:kMonthComponent]+1;
			_birthdayData.day = [pickerView selectedRowInComponent:kDayComponent]+1;
		}
			break;
		case kMonthComponent:
		{
			NSUInteger selectedMonth = row+1;
			_birthdayData.month= selectedMonth;
			//NSLog(@"选择了%d月",birthdayData.month);
			//判断选择年的这个月有多少天。更新天的数据
			if(_birthdayData.dateType == kNongLi){
				//处理闰月信息
				[self hiddenOrShowLeapMonthButton];
				//更新农历天的数据
				[self updateNongLiDay:[_dateConvert BigOrSmallMonth:selectedMonth Year:_birthdayData.year]];
			}
			else {
				[self updateGongLiDay];//更新公历天的数据
			}
			_birthdayData.year= [pickerView selectedRowInComponent:kYearComponent]+startYear;
			_birthdayData.day = [pickerView selectedRowInComponent:kDayComponent]+1;

        }
			break;
		case kDayComponent:
		{
			_birthdayData.day = row+1;
			//NSLog(@"选择了%d日",birthdayData.day);
			_birthdayData.year= [pickerView selectedRowInComponent:kYearComponent]+startYear;
			_birthdayData.month = [pickerView selectedRowInComponent:kMonthComponent]+1;
		}
			break;
		default:
			break;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"JustShowBirthdayData" object:_birthdayData];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat myWidth = self.bounds.size.width/3;
	return myWidth;
}

#pragma mark －

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
