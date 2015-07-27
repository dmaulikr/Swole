//
//  JBChartInformationView.m
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/11/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBChartInformationView.h"

// Numerics
CGFloat const kJBChartValueViewPadding = 10.0f;
CGFloat const kJBChartValueViewSeparatorSize = 0.5f;
CGFloat const kJBChartValueViewTitleHeight = 50.0f;
CGFloat const kJBChartValueViewTitleWidth = 75.0f;
CGFloat const kJBChartValueViewDefaultAnimationDuration = 0.25f;

// Colors (JBChartInformationView)
static UIColor *kJBChartViewSeparatorColor = nil;
static UIColor *kJBChartViewTitleColor = nil;
static UIColor *kJBChartViewShadowColor = nil;

// Colors (JBChartInformationView)
static UIColor *kJBChartInformationViewUnitColor = nil;
static UIColor *kJBChartInformationViewShadowColor = nil;

@interface JBChartValueView : UIView
//edited
@property (nonatomic, strong) UILabel *valueLabelOne;
@property (nonatomic, strong) UILabel *valueLabelTwo;
@property (nonatomic, strong) UILabel *valueLabelThree;
@property (nonatomic, strong) UILabel *valueLabelFour;
@property (nonatomic, strong) UILabel *valueLabelFive;

@end

@interface JBChartInformationView ()

@property (nonatomic, strong) JBChartValueView *valueView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorView;

// Position
- (CGRect)valueViewRect;
- (CGRect)titleViewRectForHidden:(BOOL)hidden;
- (CGRect)separatorViewRectForHidden:(BOOL)hidden;

@end

@implementation JBChartInformationView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [JBChartInformationView class])
	{
		kJBChartViewSeparatorColor = [UIColor blackColor];
        kJBChartViewTitleColor = [UIColor blackColor];
        kJBChartViewShadowColor = [UIColor ht_leadDarkColor];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;

        //everything above the separator
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:25.f];
        _titleLabel.numberOfLines = 1;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kJBChartViewTitleColor;
        _titleLabel.shadowColor = kJBChartViewShadowColor;
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];

        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = kJBChartViewSeparatorColor;
        [self addSubview:_separatorView];

        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        _valueView  = [[JBChartValueView alloc] initWithFrame: CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height * .3f)];
        [self addSubview:_valueView];
        
        [self setHidden:YES animated:NO];
    }
    return self;
}

#pragma mark - Position

- (CGRect)valueViewRect
{
    CGRect valueRect = CGRectZero;
    valueRect.origin.x = kJBChartValueViewPadding;
    valueRect.origin.y = kJBChartValueViewPadding + kJBChartValueViewTitleHeight;
    valueRect.size.width = self.bounds.size.width - (kJBChartValueViewPadding * 2);
    valueRect.size.height = self.bounds.size.height - valueRect.origin.y - kJBChartValueViewPadding;
    return valueRect;
}

- (CGRect)titleViewRectForHidden:(BOOL)hidden
{
    CGRect titleRect = CGRectZero;
    titleRect.origin.x = kJBChartValueViewPadding;
    titleRect.origin.y = hidden ? -kJBChartValueViewTitleHeight : kJBChartValueViewPadding;
    titleRect.size.width = self.bounds.size.width - (kJBChartValueViewPadding * 2);
    titleRect.size.height = kJBChartValueViewTitleHeight;
    return titleRect;
}

- (CGRect)separatorViewRectForHidden:(BOOL)hidden
{
    CGRect separatorRect = CGRectZero;
    separatorRect.origin.x = kJBChartValueViewPadding;
    separatorRect.origin.y = kJBChartValueViewTitleHeight;
    separatorRect.size.width = self.bounds.size.width - (kJBChartValueViewPadding * 2);
    separatorRect.size.height = kJBChartValueViewSeparatorSize;
    if (hidden)
    {
        separatorRect.origin.x -= self.bounds.size.width;
    }
    return separatorRect;
}

#pragma mark - Setters

- (void)setTitleText:(NSString *)titleText
{
    self.titleLabel.text = titleText;
    self.separatorView.hidden = !(titleText != nil);
}

//edited
- (void)setValueText:(NSMutableArray *)valueArray
{
    
    NSArray *labels = [[NSArray alloc] initWithObjects:self.valueView.valueLabelOne ,
                       self.valueView.valueLabelTwo,  self.valueView.valueLabelThree,  self.valueView.valueLabelFour,  self.valueView.valueLabelFive,  nil];
    int j = 0;
    for (int i = 0; i < [valueArray count]; i ++) {
        UILabel *label = (UILabel *)labels[i];
        label.text = (NSString *)valueArray[i];
        j++;
    }
    
    //otherwise the information from before will show
    while (j < [labels count]) {
        UILabel *label = (UILabel *)labels[j];
        label.text = @"";
        j++;
    }
    [self.valueView setNeedsLayout];
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    self.titleLabel.textColor = titleTextColor;
    [self.valueView setNeedsDisplay];
}

- (void)setValueAndUnitTextColor:(NSArray *)valueAndUnitColor
{
    NSArray *labels = [[NSArray alloc] initWithObjects:self.valueView.valueLabelOne ,
                       self.valueView.valueLabelTwo,  self.valueView.valueLabelThree,  self.valueView.valueLabelFour,  self.valueView.valueLabelFive,  nil];
    
    for (int i = 0; i < [valueAndUnitColor count]; i++) {
        UILabel *label = labels[i];
        label.textColor = valueAndUnitColor[i];
    }
    [self.valueView setNeedsDisplay];
}

- (void)setTextShadowColor:(UIColor *)shadowColor
{
    self.valueView.valueLabelFive.shadowColor = shadowColor;
    self.valueView.valueLabelFour.shadowColor = shadowColor;
    self.valueView.valueLabelThree.shadowColor = shadowColor;
    self.valueView.valueLabelTwo.shadowColor = shadowColor;
    self.valueView.valueLabelOne.shadowColor = shadowColor;
    self.titleLabel.shadowColor = shadowColor;
    [self.valueView setNeedsDisplay];
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    self.separatorView.backgroundColor = separatorColor;
    [self setNeedsDisplay];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (animated)
    {
        if (hidden)
        {
            [UIView animateWithDuration:kJBChartValueViewDefaultAnimationDuration * 0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.titleLabel.alpha = 0.0;
                self.separatorView.alpha = 0.0;
                self.valueView.valueLabelFive.alpha = 0.0;
                self.valueView.valueLabelFour.alpha = 0.0;
                self.valueView.valueLabelThree.alpha = 0.0;
                self.valueView.valueLabelTwo.alpha = 0.0;
                self.valueView.valueLabelOne.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.titleLabel.frame = [self titleViewRectForHidden:YES];
                self.separatorView.frame = [self separatorViewRectForHidden:YES];
            }];
        }
        else
        {
            [UIView animateWithDuration:kJBChartValueViewDefaultAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.titleLabel.frame = [self titleViewRectForHidden:NO];
                self.titleLabel.alpha = 1.0;
                self.valueView.valueLabelFive.alpha = 1.0;
                self.valueView.valueLabelFour.alpha = 1.0;
                self.valueView.valueLabelThree.alpha = 1.0;
                self.valueView.valueLabelTwo.alpha = 1.0;
                self.valueView.valueLabelOne.alpha = 1.0;
                self.separatorView.frame = [self separatorViewRectForHidden:NO];
                self.separatorView.alpha = 1.0;
            } completion:nil];
        }
    }
    else
    {
        self.titleLabel.frame = [self titleViewRectForHidden:hidden];
        self.titleLabel.alpha = hidden ? 0.0 : 1.0;
        self.separatorView.frame = [self separatorViewRectForHidden:hidden];
        self.separatorView.alpha = hidden ? 0.0 : 1.0;
        self.valueView.valueLabelFive.alpha = hidden ? 0.0 : 1.0;
        self.valueView.valueLabelFour.alpha = hidden ? 0.0 : 1.0;
        self.valueView.valueLabelThree.alpha = hidden ? 0.0 : 1.0;
        self.valueView.valueLabelTwo.alpha = hidden ? 0.0 : 1.0;
        self.valueView.valueLabelOne.alpha = hidden ? 0.0 : 1.0;

        
    }
}

- (void)setHidden:(BOOL)hidden
{
    [self setHidden:hidden animated:NO];
}

@end

@implementation JBChartValueView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [JBChartValueView class])
	{
        kJBChartInformationViewUnitColor = [UIColor blackColor];
        kJBChartInformationViewShadowColor = [UIColor ht_leadDarkColor];
	}
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        _valueLabelOne =[[UILabel alloc] init];
        _valueLabelTwo =[[UILabel alloc] init];
        _valueLabelThree =[[UILabel alloc] init];
        _valueLabelFour =[[UILabel alloc] init];
        _valueLabelFive =[[UILabel alloc] init];
        
        _valueLabelOne.adjustsFontSizeToFitWidth = YES;
        _valueLabelTwo.adjustsFontSizeToFitWidth = YES;
        _valueLabelThree.adjustsFontSizeToFitWidth = YES;
        _valueLabelFour.adjustsFontSizeToFitWidth = YES;
        _valueLabelFive.adjustsFontSizeToFitWidth = YES;
        
        [self setAttributesForLabel:_valueLabelFive];
        [self setAttributesForLabel:_valueLabelFour];
        [self setAttributesForLabel:_valueLabelThree];
        [self setAttributesForLabel:_valueLabelTwo];
        [self setAttributesForLabel:_valueLabelOne];

    }
    return self;
}

- (void)setAttributesForLabel:(UILabel *)labelPointer{
    labelPointer.font = [UIFont fontWithName:@"AvenirNext-Regular" size:19.f];
    labelPointer.textColor = kJBChartInformationViewUnitColor;
    labelPointer.shadowColor = kJBChartInformationViewShadowColor;
    labelPointer.shadowOffset = CGSizeMake(0, 1);
    labelPointer.backgroundColor = [UIColor clearColor];
    labelPointer.textAlignment = NSTextAlignmentLeft;
    labelPointer.adjustsFontSizeToFitWidth = YES;
    labelPointer.numberOfLines = 1;
    [self addSubview:labelPointer];
}

#pragma mark - Layout

//edited
- (void)layoutSubviews
{
    CGSize valueLabelOneSize = [self layoutForLabel:_valueLabelOne];
    CGSize valueLabelTwoSize = [self layoutForLabel:_valueLabelTwo];
    CGSize valueLabelThreeSize = [self layoutForLabel:_valueLabelThree];
    CGSize valueLabelFourSize = [self layoutForLabel:_valueLabelFour];
    CGSize valueLabelFiveSize = [self layoutForLabel:_valueLabelFive];
    [self frameForLabel:_valueLabelOne GiveSize:valueLabelOneSize Row:0];
    [self frameForLabel:_valueLabelTwo GiveSize:valueLabelTwoSize Row:1];
    [self frameForLabel:_valueLabelThree GiveSize:valueLabelThreeSize Row:2];
    [self frameForLabel:_valueLabelFour GiveSize:valueLabelFourSize Row:3];
    [self frameForLabel:_valueLabelFive GiveSize:valueLabelFiveSize Row:4];
}

- (CGSize)layoutForLabel:(UILabel *)valueLabel{
    CGSize valueLabelSize = CGSizeZero;
    if ([valueLabel.text respondsToSelector:@selector(sizeWithAttributes:)])
    {
        valueLabelSize = [valueLabel.text sizeWithAttributes:@{NSFontAttributeName:valueLabel.font}];
    }
    else
    {
        valueLabelSize = [valueLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:20.f]}];
    }
    return valueLabelSize;
}

//adjust frame for information labels
- (void)frameForLabel:(UILabel *)valueLabel GiveSize:(CGSize) size Row:(NSUInteger)row {
    valueLabel.frame = CGRectMake(20,  kJBChartValueViewTitleHeight + (size.height + 2) * row, size.width, size.height + 10);
}

@end
