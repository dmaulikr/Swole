//
//  JBChartInformationView.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/11/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIColor+HTColor.h"

@interface JBChartInformationView : UIView


/*
 * View must be initialized with a layout type (default = horizontal)
 */
- (id)initWithFrame:(CGRect)frame;

// Content
- (void)setTitleText:(NSString *)titleText;
- (void)setValueText:(NSMutableArray *)valueArray;

// Color
- (void)setTitleTextColor:(UIColor *)titleTextColor;
- (void)setValueAndUnitTextColor:(NSArray *)valueAndUnitColor;
- (void)setTextShadowColor:(UIColor *)shadowColor;
- (void)setSeparatorColor:(UIColor *)separatorColor;

// Visibility
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

@end
