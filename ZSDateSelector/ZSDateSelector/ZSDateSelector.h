//
//  DataReportDataSelector.h
//  YDCrm
//
//  Created by yylc on 16/1/13.
//  Copyright © 2016年 sansa. All rights reserved.
//

/**
 * 时间选择器（选择一个区间）
 * 点确定或是取消，ZSDateSelector自动取消
 */

#import <UIKit/UIKit.h>
#import "ZSDatePickerView.h"

/**
 * 时间选择器的宽度
 */
#define ZSDateSelectorBackWidth 240;

@protocol ZSDateSelectorDelegate;

@interface ZSDateSelector : UIView

/**
 * delegate
 */
@property (nonatomic,assign) id<ZSDateSelectorDelegate>delegate;

#pragma mark --- pickerView(日期)仅供设置属性
@property (nonatomic,strong) ZSDatePickerView *fromPicker;
@property (nonatomic,strong) ZSDatePickerView *endPicker;

#pragma mark --- cancelButton
@property (nonatomic,strong) UIColor *cancelBackColor;
@property (nonatomic,strong) UIColor *cancelNormalColor;
@property (nonatomic,strong) UIImage *cancelNormalBackImage;
@property (nonatomic,strong) UIColor *cancelSelectorColor;
@property (nonatomic,strong) UIImage *cancelSelectorBackImage;

#pragma mark --- sureButton
@property (nonatomic,strong) UIColor *sureBackColor;
@property (nonatomic,strong) UIColor *sureNormalColor;
@property (nonatomic,strong) UIImage *sureNormalBackImage;
@property (nonatomic,strong) UIColor *sureSelectorColor;
@property (nonatomic,strong) UIImage *sureSelectorBackImage;

/**
 * @brief 初始化
 *
 * @param parentView 被add的view
 * @param fromDate 起始日期
 * @param endDate 结束日期
 * @return
 */
- (instancetype)initWithParentView:(UIView *)parentView fromDate:(NSDate *)fromDate endDate:(NSDate *)endDate;

/**
 * 显示时间选择器（动画）
 */
- (void)showDateSelector;

/**
 * 隐藏时间选择器（动画）
 */
- (void)hiddenDateSelector;

@end



@protocol ZSDateSelectorDelegate <NSObject>

@optional
/**
 * @brief 确定时间区间的回调，
 *        已调用[self hiddenDateSelector];外部无需再隐藏
 *
 * @param
 * @return
 */
- (void)sureActionWithFromDate:(NSDate *)fromDate endDate:(NSDate *)endDate;

@end

