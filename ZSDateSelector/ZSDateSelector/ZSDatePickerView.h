//
//  ZSDatePickerView.h
//  ZSDatePickerView
//
//  Created by yylc on 16/1/12.
//  Copyright © 2016年 sansa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZSPickerHeight 162
#define ZSPickerHeight2 180
#define ZSPickerHeight3 216

#define ZSPickerAnimationTime 0.4

@protocol ZSDatePickerViewDelegate;

@interface ZSDatePickerView : UIView

@property (nonatomic,assign) id<ZSDatePickerViewDelegate> delegate;

@property (nonatomic,strong) NSDateFormatter *defaultFormatter;         //默认@"YYYY/MM/dd"，
@property (nonatomic,strong) NSDateFormatter *topLabelFormatter;        //默认@"YYYY年MM月dd日"，
@property (nonatomic,readonly) NSDate         *latestDate;

#pragma mark --- line
@property (nonatomic)   BOOL                 showTopLine;
@property (nonatomic)   BOOL                 showbottomLine;
@property (nonatomic)   CGRect               topLineFrame;
@property (nonatomic)   CGRect               bottomLineFrame;
@property (nonatomic,strong) UIColor         *topLineColor;
@property (nonatomic,strong) UIColor         *bottomLineColor;

#pragma mark --- label
@property (nonatomic)   CGFloat              offX;
@property (nonatomic)   CGFloat              leftLabelWidth;
@property (nonatomic,strong) UIColor         *leftLabelColor;
@property (nonatomic,strong) UIFont          *leftLabelFont;

@property (nonatomic)   NSTextAlignment      rightLabelAlifnment;
@property (nonatomic,strong) UIColor         *rightLabelColor;
@property (nonatomic,strong) UIFont          *rightLabelFont;

@property (nonatomic)   NSTextAlignment      topLabelAlifnment;
@property (nonatomic,strong) UIColor         *topLabelColor;
@property (nonatomic,strong) UIFont          *topLabelFont;

#pragma mark --- backButton
@property (nonatomic,strong) UIColor        *backButtonNormalColor;
@property (nonatomic,strong) UIColor        *backButtonSelectedColor;

#pragma mark --- batePicker
@property (nonatomic)   CGFloat              datePickerHeight;      //默认是ZSPickerHeight，有三种可选

/**
 * @brief 初始化
 *
 * @param frame，view的高度，不包括datepicker
 * @return
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title date:(NSDate *)date;

/**
 * @brief datepicker上添加view
 *
 * @param
 * @return
 */
- (void)datePickerAddView:(UIView *)view;

/**
 *  datepicker上insertView
 *
 *  @param view
 *  @param index
 */
- (void)datePickerInsertView:(UIView *)view atIndex:(NSInteger)index;

/**
 *  可自定义替换picker
 *
 *  @param picker
 */
- (void)customDatePicker:(UIDatePicker *)picker;

#pragma mark --- animation
- (void)showDatePickerAnimation:(BOOL)animation;

- (void)hiddenDatePickerAnimation:(BOOL)animation;

#pragma mark --- 判断
- (BOOL)datePickerIsShow;

- (BOOL)titleLabelIsSeleted;
@end



@protocol ZSDatePickerViewDelegate <NSObject>

@optional

- (void)ZSDatePickerViewDidPickerValueChangeWithDate:(NSDate *)date;

- (void)ZSDatePickerViewWillShow:(ZSDatePickerView *)datePicker;

- (void)ZSDatePickerViewDidShow:(ZSDatePickerView *)datePicker;

- (void)ZSDatePickerViewWillHidden:(ZSDatePickerView *)datePicker;

- (void)ZSDatePickerViewDidHidden:(ZSDatePickerView *)datePicker;

@end






