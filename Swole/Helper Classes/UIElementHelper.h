//
//  UIElementHelper.h
//  Swole
//
//  Created by gamaux01 on 2015/6/18.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BButton.h"
#import "UIColor+HTColor.h"


@interface UIElementHelper : NSObject

+ (BButton *)createRectangularButtonWithText:(NSString *)text FontSize:(CGFloat)fontSize Color:(UIColor *)buttonColor AtLocation:(CGRect)frame;

+ (UIView *)createBlankViewWithText:(NSString *)text Frame:(CGRect)frame Screen:(CGRect)screen;

@end

