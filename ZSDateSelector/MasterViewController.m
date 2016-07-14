//
//  MasterViewController.m
//  ZSDateSelector
//
//  Created by yylc on 16/4/21.
//  Copyright © 2016年 sansa. All rights reserved.
//

#import "MasterViewController.h"
#import "ZSDateSelector.h"

@interface MasterViewController ()<ZSDateSelectorDelegate>
#pragma mark --- view
@property (nonatomic,strong) UILabel    *lable;

#pragma mark --- date
@property (nonatomic,strong) NSDateFormatter        *dateFormatter;
@property (nonatomic,strong) NSDate                 *formDate;
@property (nonatomic,strong) NSDate                 *endDate;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"yyyy年M月d日"];
    self.endDate = [NSDate date];
    self.formDate = [NSDate date];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100,100 , 100, 100)];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:lable];
    lable.text = [NSString stringWithFormat:@"%@ -- %@",[_dateFormatter stringFromDate:_formDate],[_dateFormatter stringFromDate:_endDate]];
    self.lable = lable;
}

- (void)buttonAction
{
    ZSDateSelector *seleter = [[ZSDateSelector alloc]initWithParentView:self.view.window fromDate:_formDate endDate:_endDate];
    seleter.delegate = self;
    seleter.sureBackColor = [UIColor greenColor];
    seleter.cancelBackColor = [UIColor greenColor];
    [seleter showDateSelector];
}

#pragma mark ---
#pragma mark --- ZSDateSelectorDelegate
- (void)sureActionWithFromDate:(NSDate *)fromDate endDate:(NSDate *)endDate
{
    if([fromDate timeIntervalSince1970] <= [endDate timeIntervalSince1970]) {
        self.formDate = fromDate;
        self.endDate = endDate;
    } else {
        self.formDate = endDate;
        self.endDate = fromDate;
    }
    _lable.text = [NSString stringWithFormat:@"%@ -- %@",[_dateFormatter stringFromDate:_formDate],[_dateFormatter stringFromDate:_endDate]];
}
@end
