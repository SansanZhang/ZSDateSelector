//
//  DataReportDataSelector.m
//  YDCrm
//
//  Created by yylc on 16/1/13.
//  Copyright © 2016年 sansa. All rights reserved.
//


#import "ZSDateSelector.h"
#import "AMBlurView.h"

static inline BOOL FK_IS_HIGHT_ThAN_IOS7 (){
    return ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO;
}

@interface ZSDateSelector()<ZSDatePickerViewDelegate>
//判断是否显示了
@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,strong) UIView    *parentView;
@property (nonatomic,strong) UIView    *dateAlertView;
@property (nonatomic,strong) UIControl *backControl;
@property (nonatomic,strong) UIView    *maskView;
@property (nonatomic,strong) UIButton  *cancelButton;
@property (nonatomic,strong) UIButton  *sureButton;

@end

@implementation ZSDateSelector

- (instancetype)initWithParentView:(UIView *)parentView fromDate:(NSDate *)fromDate endDate:(NSDate *)endDate
{
    self = [super initWithFrame:parentView.bounds];
    if (self) {
        self.isShow = NO;
        
        for (UIView *view in parentView.subviews) {
            if ([view isKindOfClass:[ZSDateSelector class]]) {
                self.isShow  = YES;
            }
        }
        if (!_isShow) {
            self.parentView = parentView;
            self.backgroundColor = [UIColor clearColor];
            UIControl *backgroundView = [[UIControl alloc]initWithFrame:self.bounds];
            backgroundView.backgroundColor = [UIColor clearColor];
            backgroundView.userInteractionEnabled = NO;
            [backgroundView addTarget:self action:@selector(backViewACtion) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *maskView = [[UIView alloc]initWithFrame:backgroundView.bounds];
            maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
            maskView.alpha = 0;
            maskView.userInteractionEnabled = NO;
            [backgroundView addSubview:maskView];
            [self addSubview:backgroundView];
            self.maskView = maskView;
            self.backControl = backgroundView;
            self.dateAlertView = [self dateSelectedAlertViewWithFromDate:fromDate endDate:endDate];
            [self addSubview:_dateAlertView];
            [parentView addSubview:self];
        }
    }
    return self;
}

#pragma mark --- view
- (UIView *)dateSelectedAlertViewWithFromDate:(NSDate *)fromDate endDate:(NSDate *)endDate
{
    NSInteger buttonOff = 15;
    NSInteger backWidth = ZSDateSelectorBackWidth;
    NSInteger buttonWidth = (backWidth - buttonOff*3)/2;
    NSInteger buttonHeight = 36;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width - backWidth)/2, (self.frame.size.height - 220)*0.4, backWidth, 255)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 3;
    view.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, view.frame.size.width, 45)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请选择日期";
    [view addSubview:label];
    
    NSDate *fDate = [NSDate date];
    if (fromDate) {
        fDate = fromDate;
    }
    ZSDatePickerView *picker = [[ZSDatePickerView alloc]initWithFrame:CGRectMake(0, 70, view.frame.size.width, 40) title:@"起始日期" date:fDate];
    picker.tag  = 100;
    picker.delegate = self;
    [picker datePickerInsertView:[self blurViewWithFrame:CGRectMake(0, 0, view.frame.size.width, ZSPickerHeight)] atIndex:0];
    picker.offX = 20;
    picker.backButtonNormalColor = [UIColor whiteColor];
    picker.backButtonSelectedColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    picker.leftLabelFont = [UIFont systemFontOfSize:14];
    picker.leftLabelColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    picker.rightLabelColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    picker.rightLabelFont = [UIFont systemFontOfSize:14];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年M月d日"];
    picker.defaultFormatter = formatter;
    picker.topLabelFormatter = formatter;
    picker.topLabelColor = [UIColor blueColor];
    picker.topLabelFont = [UIFont systemFontOfSize:14];
    self.fromPicker = picker;
    [view addSubview:picker];
    
    NSDate *eDate = [NSDate date];
    if (endDate) {
        eDate = endDate;
    }
    picker = [[ZSDatePickerView alloc]initWithFrame:CGRectMake(0, 110, view.frame.size.width, 40) title:@"结束日期" date:eDate];
    picker.tag = 101;
    picker.delegate = self;
    picker.showTopLine = NO;
    [picker datePickerInsertView:[self blurViewWithFrame:CGRectMake(0, 0, view.frame.size.width, ZSPickerHeight)] atIndex:0];
    picker.offX = 20;
    picker.backButtonNormalColor = [UIColor whiteColor];
    picker.backButtonSelectedColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    picker.leftLabelFont = [UIFont systemFontOfSize:14];
    picker.leftLabelColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    picker.rightLabelColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    picker.rightLabelFont = [UIFont systemFontOfSize:14];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy年M月d日"];
    picker.defaultFormatter = formatter1;
    picker.topLabelFormatter = formatter1;
    picker.topLabelColor = [UIColor blueColor];
    picker.topLabelFont = [UIFont systemFontOfSize:14];
    self.endPicker = picker;
    [view addSubview:picker];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(buttonOff, view.frame.size.height - 70, buttonWidth, buttonHeight)];
    cancel.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancel addTarget:self action:@selector(hiddenDateSelector) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton = cancel;
    [view addSubview:cancel];
    
    UIButton *sure = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width - buttonOff - buttonWidth , view.frame.size.height - 70, buttonWidth, buttonHeight)];
    sure.titleLabel.font = [UIFont systemFontOfSize:13];
    [sure addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [sure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    self.sureButton = sure;
    [view addSubview:sure];
    return view;
}

- (AMBlurView *)blurViewWithFrame:(CGRect)frame
{
    if (FK_IS_HIGHT_ThAN_IOS7()) {
        AMBlurView *blurView = [[AMBlurView alloc] initWithFrame:frame];
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        blurView.blurTintColor = [UIColor colorWithWhite:1 alpha:0.5];
        return blurView;
    }
    return nil;
}

#pragma mark --- action
- (void)backViewACtion
{
    [self hiddenDateSelector];
}

- (void)sureButtonAction
{
    [self hiddenDateSelector];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureActionWithFromDate:endDate:)]) {
        [self.delegate sureActionWithFromDate:self.fromPicker.latestDate endDate:self.endPicker.latestDate];
    }
}
#pragma mark --- animation
- (void)showDateSelector
{
    if (!_isShow) {
        self.userInteractionEnabled = NO;
        _maskView.alpha = 0.5;
        _dateAlertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9, 0.9);
        __weak typeof(self) wself = self;
        [UIView animateWithDuration:0.2 animations: ^(void){
            wself.dateAlertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
            wself.dateAlertView.alpha = 0.5;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.1 animations: ^(void){
                wself.dateAlertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9, 0.9);
                wself.dateAlertView.alpha = 0.8;
            }completion:^(BOOL finished){
                [UIView animateWithDuration:0.1 animations: ^(void){
                    wself.dateAlertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1, 1);
                    wself.dateAlertView.alpha = 1.0;
                }completion:^(BOOL finished){
                    wself.userInteractionEnabled = YES;
                }];
            }];
        }];

    }
}

- (void)hiddenDateSelector
{
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.maskView.alpha = 0;
        wself.alpha = 0;
    } completion:^(BOOL finished){
        [wself removeFromSuperview];
    }];
}


#pragma ZSDatePickerViewDelegate
- (void)ZSDatePickerViewWillShow:(ZSDatePickerView *)datePicker
{
    __weak typeof(self) wself = self;
    if (datePicker.tag == 100) {
        [UIView animateWithDuration:ZSPickerAnimationTime animations:^{
            wself.dateAlertView.frame = CGRectMake(wself.dateAlertView.frame.origin.x, (wself.frame.size.height - 220 - ZSPickerHeight)*0.4, wself.dateAlertView.frame.size.width, wself.dateAlertView.frame.size.height);
            wself.endPicker.frame = CGRectMake(wself.endPicker.frame.origin.x, wself.endPicker.frame.origin.y + ZSPickerHeight, wself.endPicker.frame.size.width, wself.endPicker.frame.size.height);
            wself.endPicker.showTopLine = YES;
            if (![wself.endPicker datePickerIsShow]) {
                wself.cancelButton.frame = CGRectMake(wself.cancelButton.frame.origin.x, wself.cancelButton.frame.origin.y + ZSPickerHeight, wself.cancelButton.frame.size.width, wself.cancelButton.frame.size.height);
                wself.sureButton.frame = CGRectMake(wself.sureButton.frame.origin.x, wself.sureButton.frame.origin.y + ZSPickerHeight, wself.sureButton.frame.size.width, wself.sureButton.frame.size.height);
                wself.dateAlertView.frame = CGRectMake(wself.dateAlertView.frame.origin.x, wself.dateAlertView.frame.origin.y, wself.dateAlertView.frame.size.width, wself.dateAlertView.frame.size.height + ZSPickerHeight);
            }else{
                [wself.endPicker hiddenDatePickerAnimation:YES];
            }
        } completion:^(BOOL finished) {
            
        }];
    }else if (datePicker.tag == 101){
        [UIView animateWithDuration:ZSPickerAnimationTime animations:^{
            wself.dateAlertView.frame = CGRectMake(wself.dateAlertView.frame.origin.x, (wself.frame.size.height - 220 - ZSPickerHeight)*0.4, wself.dateAlertView.frame.size.width, wself.dateAlertView.frame.size.height);
            if (![wself.fromPicker datePickerIsShow]) {
                wself.cancelButton.frame = CGRectMake(wself.cancelButton.frame.origin.x, wself.cancelButton.frame.origin.y + ZSPickerHeight, wself.cancelButton.frame.size.width, wself.cancelButton.frame.size.height);
                wself.sureButton.frame = CGRectMake(wself.sureButton.frame.origin.x, wself.sureButton.frame.origin.y + ZSPickerHeight, wself.sureButton.frame.size.width, wself.sureButton.frame.size.height);
                wself.dateAlertView.frame = CGRectMake(wself.dateAlertView.frame.origin.x, wself.dateAlertView.frame.origin.y, wself.dateAlertView.frame.size.width, wself.dateAlertView.frame.size.height + ZSPickerHeight);
            }else{
                wself.endPicker.frame = CGRectMake(wself.endPicker.frame.origin.x, wself.endPicker.frame.origin.y - ZSPickerHeight, wself.endPicker.frame.size.width, wself.endPicker.frame.size.height);
                [wself.fromPicker hiddenDatePickerAnimation:YES];
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)ZSDatePickerViewWillHidden:(ZSDatePickerView *)datePicker
{
    __weak typeof(self) wself = self;
    if (datePicker.tag == 100) {
        [UIView animateWithDuration:ZSPickerAnimationTime animations:^{
            wself.endPicker.showTopLine = NO;
            if (![wself.endPicker titleLabelIsSeleted]) {
                wself.dateAlertView.frame = CGRectMake(wself.dateAlertView.frame.origin.x, (wself.frame.size.height - 220)*0.4, wself.dateAlertView.frame.size.width, wself.dateAlertView.frame.size.height);
                wself.endPicker.frame = CGRectMake(wself.endPicker.frame.origin.x, wself.endPicker.frame.origin.y - ZSPickerHeight, wself.endPicker.frame.size.width, wself.endPicker.frame.size.height);
                wself.cancelButton.frame = CGRectMake(wself.cancelButton.frame.origin.x, wself.cancelButton.frame.origin.y - ZSPickerHeight, wself.cancelButton.frame.size.width, wself.cancelButton.frame.size.height);
                wself.sureButton.frame = CGRectMake(wself.sureButton.frame.origin.x, wself.sureButton.frame.origin.y - ZSPickerHeight, wself.sureButton.frame.size.width, wself.sureButton.frame.size.height);
                wself.dateAlertView.frame = CGRectMake(wself.dateAlertView.frame.origin.x, wself.dateAlertView.frame.origin.y, wself.dateAlertView.frame.size.width, wself.dateAlertView.frame.size.height - ZSPickerHeight);
            }
        } completion:^(BOOL finished) {
            
        }];
    }else if (datePicker.tag == 101){
        [UIView animateWithDuration:ZSPickerAnimationTime animations:^{
            if (![wself.fromPicker titleLabelIsSeleted]) {
                wself.endPicker.showTopLine = NO;
                wself.dateAlertView.frame = CGRectMake(wself.dateAlertView.frame.origin.x, (wself.frame.size.height - 220)*0.4, wself.dateAlertView.frame.size.width, wself.dateAlertView.frame.size.height);
                wself.cancelButton.frame = CGRectMake(wself.cancelButton.frame.origin.x, wself.cancelButton.frame.origin.y - ZSPickerHeight, wself.cancelButton.frame.size.width, wself.cancelButton.frame.size.height);
                wself.sureButton.frame = CGRectMake(wself.sureButton.frame.origin.x, wself.sureButton.frame.origin.y - ZSPickerHeight, wself.sureButton.frame.size.width, wself.sureButton.frame.size.height);
                wself.dateAlertView.frame = CGRectMake(wself.dateAlertView.frame.origin.x, wself.dateAlertView.frame.origin.y, wself.dateAlertView.frame.size.width, wself.dateAlertView.frame.size.height - ZSPickerHeight);
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)setCancelBackColor:(UIColor *)cancelBackColor
{
    if (_cancelButton) {
        [_cancelButton setBackgroundColor:cancelBackColor];
    }
}

- (void)setCancelNormalColor:(UIColor *)cancelNormalColor
{
    if (_cancelButton) {
        [_cancelButton setTitleColor:cancelNormalColor forState:UIControlStateNormal];
    }
}

- (void)setCancelSelectorColor:(UIColor *)cancelSelectorColor
{
    if (_cancelButton) {
        [_cancelButton setTitleColor:cancelSelectorColor forState:UIControlStateSelected];
    }
}

- (void)setCancelNormalBackImage:(UIImage *)cancelNormalBackImage
{
    if (_cancelButton) {
        [_cancelButton setBackgroundImage:cancelNormalBackImage forState:UIControlStateNormal];
    }
}

- (void)setCancelSelectorBackImage:(UIImage *)cancelSelectorBackImage
{
    if (_cancelButton) {
        [_cancelButton setBackgroundImage:cancelSelectorBackImage forState:UIControlStateSelected];
    }
}

- (void)setSureBackColor:(UIColor *)sureBackColor
{
    if (_sureButton) {
        [_sureButton setBackgroundColor:sureBackColor];
    }
}

- (void)setSureNormalColor:(UIColor *)sureNormalColor
{
    if (_sureButton) {
        [_sureButton setTitleColor:sureNormalColor forState:UIControlStateNormal];
    }
}

- (void)setSureSelectorColor:(UIColor *)sureSelectorColor
{
    if (_sureButton) {
        [_sureButton setTitleColor:sureSelectorColor forState:UIControlStateSelected];
    }
}

- (void)setSureNormalBackImage:(UIImage *)sureNormalBackImage
{
    if (_sureButton) {
        [_sureButton setBackgroundImage:sureNormalBackImage forState:UIControlStateNormal];
    }
}

- (void)setSureSelectorBackImage:(UIImage *)sureSelectorBackImage
{
    if (_sureButton) {
        [_sureButton setBackgroundImage:sureSelectorBackImage forState:UIControlStateSelected];
    }
}
@end
