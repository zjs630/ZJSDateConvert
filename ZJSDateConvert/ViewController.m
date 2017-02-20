//
//  ViewController.m
//  ZJSDateConvert
//
//  Created by ZhangJingshun on 2017/2/20.
//  Copyright © 2017年 zjs. All rights reserved.
//

#import "ViewController.h"

#import "BirthdayData.h"
#import "DateViewController.h"


@interface ViewController ()

@property (nonatomic,strong) DateViewController *dateViewController;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOneBirthdayData:) name:@"SaveDataAndCloseView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(justShowBirthdayData:) name:@"JustShowBirthdayData" object:nil];
}

- (IBAction)show {
    if (_dateViewController == nil) {
        _dateViewController = [[DateViewController alloc] initWithFrame:CGRectMake(0,44, self.view.bounds.size.width, self.view.bounds.size.height)];
        [_dateViewController setupDefaultDate:nil];
        [self.view addSubview:_dateViewController.view];
    }
}

-(void)setOneBirthdayData:(NSNotification *)notifi{
    //BirthdayData *tempData = (BirthdayData *)[notifi object];
    //......进行日期本地存储。
    if (_dateViewController) {
        [_dateViewController.view removeFromSuperview];
        _dateViewController = nil;
    }
    
}

-(void)justShowBirthdayData:(NSNotification *)notifi{
    BirthdayData *tempData = (BirthdayData *)[notifi object];
    NSString *temp2 = [self oneBirthdayString:tempData];
    _dateLabel.text = temp2;
}

-(NSString *)oneBirthdayString:(BirthdayData *)oneData{
    NSString *temp1 = nil;
    oneData.dateType == kGongLi ? (temp1 = @"公历") : (temp1 = @"农历");
    
    NSString *temp2 = nil;
    if (oneData.isRunYue) {
        temp2 = [NSString stringWithFormat:@"%@闰月 %lu年%lu月%lu日",temp1,oneData.year,oneData.month,oneData.day];
    }
    else {
        temp2 = [NSString stringWithFormat:@"%@     %lu年%lu月%lu日",temp1,oneData.year,oneData.month,oneData.day];
    }
    return temp2;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
