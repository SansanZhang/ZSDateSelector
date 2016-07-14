//
//  ZSDatePickerView.m
//  ZSDatePickerView
//
//  Created by yylc on 16/1/12.
//  Copyright © 2016年 sansa. All rights reserved.
//

#import "ZSDatePickerView.h"

@interface UIImage (ZSImage)


@end

@implementation UIImage (ZSImage)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 5, 5);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRect:rect];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

@end

@interface ZSDatePickerView()
{
    NSInteger _insertIndex;
}

@property (nonatomic,strong) UIButton       *backButton;
@property (nonatomic,strong) UILabel        *rightLabel;
@property (nonatomic,strong) UILabel        *leftLabel;
@property (nonatomic,strong) UILabel        *topLabel;
@property (nonatomic,strong) UIDatePicker   *datePicker;
@property (nonatomic,strong) UIDatePicker   *customerPicker;
@property (nonatomic,strong) UIView         *topline;
@property (nonatomic,strong) UIView         *bottomLine;
@property (nonatomic,strong) NSDate         *latestDate;

@property (nonatomic,strong) UIView         *addView;
@property (nonatomic,strong) UIView         *insertView;

@end

@implementation ZSDatePickerView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title date:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.topLineColor = [UIColor colorWithWhite:0.88 alpha:1];
        self.bottomLineColor = [UIColor colorWithWhite:0.88 alpha:1];
        self.topLineFrame = CGRectMake(0, 0, self.frame.size.width, [self lineOnePixel]);
        self.bottomLineFrame = CGRectMake(0, self.frame.size.height - [self lineOnePixel], self.frame.size.width, [self lineOnePixel]);
        self.offX = 10;
        self.leftLabelWidth = self.frame.size.width/2 - _offX;
        self.leftLabelColor = [UIColor colorWithWhite:0.25 alpha:1.0];
        self.leftLabelFont = [UIFont systemFontOfSize:15];
        
        self.rightLabelAlifnment = NSTextAlignmentRight;
        self.rightLabelColor = [UIColor colorWithWhite:0.25 alpha:1.0];
        self.rightLabelFont = [UIFont systemFontOfSize:15];
        
        self.topLabelAlifnment = NSTextAlignmentLeft;
        self.topLabelColor = [UIColor blueColor];
        self.topLabelFont = [UIFont systemFontOfSize:15];
        
        self.backButtonNormalColor = [UIColor whiteColor];
        self.backButtonSelectedColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        self.datePickerHeight = ZSPickerHeight;
        self.latestDate = [NSDate date];
        
        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_backButton setBackgroundImage:[UIImage imageWithColor:_backButtonNormalColor] forState:UIControlStateNormal];
        [_backButton setBackgroundImage:[UIImage imageWithColor:_backButtonSelectedColor] forState:UIControlStateSelected];
        [_backButton setBackgroundImage:[UIImage imageWithColor:_backButtonSelectedColor] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(_offX, 0, _leftLabelWidth, self.frame.size.height)];
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.font = _leftLabelFont;
        _leftLabel.textColor = _leftLabelColor;
        
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2 - _offX, self.frame.size.height)];
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.textAlignment = _rightLabelAlifnment;
        _rightLabel.font = _rightLabelFont;
        _rightLabel.textColor = _rightLabelColor;
        
        self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(_offX, 0, self.frame.size.width - _offX*2, self.frame.size.height)];
        _topLabel.backgroundColor = [UIColor clearColor];
        _topLabel.font = _topLabelFont;
        _topLabel.textColor = _topLabelColor;
        _topLabel.hidden = YES;
        
        UIView *line1 = [[UIView alloc]initWithFrame:_topLineFrame];
        line1.backgroundColor = _topLineColor;
        self.topline = line1;
        
        UIView *line2 = [[UIView alloc]initWithFrame:_bottomLineFrame];
        line2.backgroundColor = _bottomLineColor;
        self.bottomLine = line2;
        
        [self addSubview:_backButton];
        [_backButton addSubview:_leftLabel];
        [_backButton addSubview:_rightLabel];
        [_backButton addSubview:_topLabel];
        [_backButton addSubview:line1];
        [_backButton addSubview:line2];
        self.datePicker = [self datePicker];
        
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY/MM/dd"];
        self.defaultFormatter = dateformatter;
        
        NSDateFormatter *changeFormatter=[[NSDateFormatter alloc] init];
        [changeFormatter setDateFormat:@"YYYY年M月d日"];
        self.topLabelFormatter = changeFormatter;
        
        if (title) {
            _leftLabel.text = title;
        }else{
            _leftLabel.text = @"起始时间";
        }
        
        NSDate *titleDate = [NSDate date];
        if (date) {
            titleDate = date;
            _latestDate = date;
        }
        _rightLabel.text = [NSString stringWithFormat:@"%@",[self dateFormatterWithDate:titleDate formatter:_defaultFormatter]];
    }
    return self;
}

- (CGFloat)lineOnePixel {
    return ((([[UIScreen mainScreen]scale]>1)?YES:NO))?(((fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)736 ) < DBL_EPSILON))?0.66:0.5):1;;
}

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        UIDatePicker *picker;
        if (self.customerPicker) {
            picker = [self.customerPicker copy];
        }else{
            picker = [[UIDatePicker alloc]init];
            picker.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            picker.datePickerMode = UIDatePickerModeDate;
            picker.userInteractionEnabled = YES;
            if (_latestDate) {
                picker.date = _latestDate;
            }
            picker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"];
            [picker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
            picker.hidden = YES;
            if (self.addView) {
                [picker addSubview:_addView];
            }
            if (self.insertView) {
                [picker insertSubview:_insertView atIndex:_insertIndex];
            }
        }
        [self addSubview:picker];
        picker.layer.zPosition = -1;
        self.datePicker = picker;
    }
    return _datePicker;
}

- (void)labelShowHiddenChange:(BOOL)show
{
    _topLabel.hidden = !show;
    _leftLabel.hidden = show;
    _rightLabel.hidden = show;
}

#pragma mark ---
#pragma data
- (NSString *)dateFormatterWithDate:(NSDate *)date formatter:(NSDateFormatter *)formatter
{
    NSString *locationString=[formatter stringFromDate:date];
    return locationString;
}

#pragma mark ---
#pragma action
- (void)backButtonAction:(UIButton *)button
{
    if (self.datePicker.hidden) {
        [self labelShowHiddenChange:YES];
        [self showDatePickerAnimation:YES];
    }else{
        [self labelShowHiddenChange:NO];
        [self hiddenDatePickerAnimation:YES];
    }
}

- (void)datePickerAction:(UIDatePicker *)picker
{
    _latestDate = picker.date;
    _rightLabel.text = [self dateFormatterWithDate:picker.date formatter:_defaultFormatter];
    _topLabel.text = [self dateFormatterWithDate:picker.date formatter:_topLabelFormatter];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZSDatePickerViewDidPickerValueChangeWithDate:)]) {
        [self.delegate ZSDatePickerViewDidPickerValueChangeWithDate:picker.date];
    }
}

#pragma mark ---
#pragma animation
- (void)showDatePickerAnimation:(BOOL)animation
{
    __weak typeof(self) wself = self;
    if (animation) {
        if (!_latestDate) {
            _latestDate = [NSDate date];
        }
        _topLabel.hidden = NO;
        _topLabel.text = [self dateFormatterWithDate:_latestDate formatter:_topLabelFormatter];
        self.datePicker.date = _latestDate;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZSDatePickerViewWillShow:)]) {
            [self.delegate ZSDatePickerViewWillShow:self];
        }
        [UIView animateWithDuration:ZSPickerAnimationTime animations:^{
            [wself labelShowHiddenChange:YES];
            CGRect frame = wself.datePicker.frame;
            frame.origin.y = wself.frame.size.height;
            frame.size.height = wself.datePickerHeight;
            wself.datePicker.frame = frame;
            wself.datePicker.hidden = NO;
            
            CGRect frameSelf = wself.frame;
            frameSelf.size.height = wself.frame.size.height + wself.datePickerHeight;
            wself.frame = frameSelf;
        } completion:^(BOOL finished) {
            if (wself.delegate && [wself.delegate respondsToSelector:@selector(ZSDatePickerViewDidShow:)]) {
                [wself.delegate ZSDatePickerViewDidShow:wself];
            }
        }];
    }else{
        
    }
}

- (void)hiddenDatePickerAnimation:(BOOL)animation
{
    if (animation) {
        __weak typeof(self) wself = self;
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZSDatePickerViewWillHidden:)]) {
            [self.delegate ZSDatePickerViewWillHidden:self];
        }
        [UIView animateWithDuration:ZSPickerAnimationTime animations:^{
            [wself labelShowHiddenChange:NO];
            CGRect frameSelf = wself.frame;
            frameSelf.size.height = wself.frame.size.height - wself.datePickerHeight;
            wself.frame = frameSelf;
            
            CGRect frame = wself.datePicker.frame;
            frame.origin.y = - (wself.datePickerHeight - self.frame.size.height)/2;
            frame.size.height = wself.datePickerHeight;
            wself.datePicker.frame = frame;
        } completion:^(BOOL finished) {
            wself.datePicker.hidden = YES;
            [wself.datePicker removeFromSuperview];
            wself.datePicker = nil;
            if (wself.delegate && [wself.delegate respondsToSelector:@selector(ZSDatePickerViewDidHidden:)]) {
                [wself.delegate ZSDatePickerViewDidHidden:wself];
            }
        }];
    }else{
        
    }
}

//datepicker上添加view
- (void)datePickerAddView:(UIView *)view
{
    self.addView = view;
    [_datePicker addSubview:view];
}

- (void)datePickerInsertView:(UIView *)view atIndex:(NSInteger)index
{
    self.insertView = view;
    _insertIndex = index;
    [_datePicker insertSubview:view atIndex:index];
}

- (void)customDatePicker:(UIDatePicker *)picker
{
    self.customerPicker = picker;
}

- (BOOL)datePickerIsShow
{
    if (_datePicker) {
        return (!_datePicker.hidden);
    }else{
        return NO;
    }
}

- (BOOL)titleLabelIsSeleted
{
    if (_backButton) {
        if (_backButton.state == UIControlStateHighlighted || _backButton.state == UIControlStateSelected) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
#pragma mark --- Properties
- (void)setDefaultFormatter:(NSDateFormatter *)defaultFormatter
{
    _defaultFormatter = defaultFormatter;
    if (_rightLabel) {
        _rightLabel.text = [self dateFormatterWithDate:_latestDate formatter:_defaultFormatter];
    }
}

- (void)setChangeFormatter:(NSDateFormatter *)changeFormatter
{
    _topLabelFormatter = changeFormatter;
}

- (void)setShowTopLine:(BOOL)showTopLine
{
    _showbottomLine = showTopLine;
    if (_topline) { _topline.hidden = !showTopLine; }
}

- (void)setShowbottomLine:(BOOL)showbottomLine
{
    _showbottomLine = showbottomLine;
    if (_bottomLine) { _bottomLine.hidden = !showbottomLine; }
}

- (void)setTopLineFrame:(CGRect)topLineFrame
{
    _topLineFrame = topLineFrame;
    if (_topline) { _topline.frame = topLineFrame; }
}

- (void)setTopLineColor:(UIColor *)topLineColor
{
    _topLineColor = topLineColor;
    if (_topline) { _topline.backgroundColor = topLineColor; }
}

- (void)setBottomLineFrame:(CGRect)bottomLineFrame
{
    _bottomLineFrame = bottomLineFrame;
    if (_bottomLine) { _bottomLine.frame = bottomLineFrame; }
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor
{
    _bottomLineColor = bottomLineColor;
    if (_bottomLine) { _bottomLine.backgroundColor = bottomLineColor; }
}

- (void)setOffX:(CGFloat)offX
{
    _offX = offX;
    if (_leftLabel) {
        CGRect lframe = _leftLabel.frame;
        lframe.origin.x = offX;
        _leftLabel.frame = lframe;
    }
    
    if (_rightLabel) {
        CGRect rframe = _rightLabel.frame;
        rframe.size.width = self.frame.size.width/2 - offX;
        _rightLabel.frame = rframe;
    }
    
    if (_topLabel) {
        CGRect tframe = _topLabel.frame;
        tframe.origin.x = offX;
        tframe.size.width = self.frame.size.width - offX*2;
        _topLabel.frame = tframe;
    }
}

- (void)setLeftLabelWidth:(CGFloat)leftLabelWidth
{
    _leftLabelWidth = leftLabelWidth;
    if (_leftLabel) {
        CGRect lframe = _leftLabel.frame;
        lframe.size.width = leftLabelWidth;
        _leftLabel.frame = lframe;
    }
}

- (void)setLeftLabelColor:(UIColor *)leftLabelColor
{
    _leftLabelColor = leftLabelColor;
    if (_leftLabel) { _leftLabel.textColor = leftLabelColor; }
}

- (void)setLeftLabelFont:(UIFont *)leftLabelFont
{
    _leftLabelFont = leftLabelFont;
    if (_leftLabel) { _leftLabel.font = leftLabelFont; }
}

- (void)setRightLabelAlifnment:(NSTextAlignment)rightLabelAlifnment
{
    _rightLabelAlifnment = rightLabelAlifnment;
    if (_rightLabel) { _rightLabel.textAlignment = rightLabelAlifnment; }
}

- (void)setRightLabelColor:(UIColor *)rightLabelColor
{
    _rightLabelColor = rightLabelColor;
    if (_rightLabel) { _rightLabel.textColor = rightLabelColor; }
}

- (void)setRightLabelFont:(UIFont *)rightLabelFont
{
    _rightLabelFont = rightLabelFont;
    if (_rightLabel) { _rightLabel.font = _rightLabelFont; }
}

- (void)setTopLabelAlifnment:(NSTextAlignment)topLabelAlifnment
{
    _topLabelAlifnment = topLabelAlifnment;
    if (_topLabel) { _topLabel.textAlignment = topLabelAlifnment; }
}

- (void)setTopLabelColor:(UIColor *)topLabelColor
{
    _topLabelColor = topLabelColor;
    if (_topLabel) { _topLabel.textColor = topLabelColor; }
}

- (void)setTopLabelFont:(UIFont *)topLabelFont
{
    _topLabelFont = topLabelFont;
    if (_topLabel) { _topLabel.font = topLabelFont; }
}

- (void)setBackButtonNormalColor:(UIColor *)backButtonNormalColor
{
    _backButtonNormalColor = backButtonNormalColor;
    if (_backButton) {
        [_backButton setBackgroundImage:[UIImage imageWithColor:backButtonNormalColor] forState:UIControlStateNormal];
    }
}

- (void)setBackButtonSelectedColor:(UIColor *)backButtonSelectedColor
{
    _backButtonSelectedColor = backButtonSelectedColor;
    if (_backButton) {
        [_backButton setBackgroundImage:[UIImage imageWithColor:backButtonSelectedColor] forState:UIControlStateSelected];
        [_backButton setBackgroundImage:[UIImage imageWithColor:backButtonSelectedColor] forState:UIControlStateHighlighted];
    }
}

- (void)setDatePickerHeight:(CGFloat)datePickerHeight
{
    _datePickerHeight = datePickerHeight;
}
@end
