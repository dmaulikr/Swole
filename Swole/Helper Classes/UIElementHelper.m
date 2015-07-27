//
//  UIElementHelper.m
//  Swole
//
//  Created by gamaux01 on 2015/6/18.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "UIElementHelper.h"

@implementation UIElementHelper

+ (BButton *)createRectangularButtonWithText:(NSString *)text FontSize:(CGFloat)fontSize Color:(UIColor *)buttonColor AtLocation:(CGRect)frame {
    BButton *rectButton = [[BButton alloc] initWithFrame:frame color:buttonColor style:BButtonStyleBootstrapV3];
    rectButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rectButton setTitle:text forState:UIControlStateNormal];
    [rectButton.titleLabel setFont: [UIFont fontWithName:@"AvenirNext-Regular" size:fontSize]];
    return rectButton;
}

+ (UIView *)createBlankViewWithText:(NSString *)text Frame:(CGRect)frame Screen:(CGRect)screen {
    
    //ash colored view
    UIView *blankView = [[UIView alloc] initWithFrame:frame];
    blankView.backgroundColor = [UIColor ht_ashColor];
    
    //label with tag = 1
    UILabel *blankViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height/1.5f)];
    blankViewLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:20];
    blankViewLabel.numberOfLines = 1;
    blankViewLabel.shadowColor = [UIColor lightTextColor];
    blankViewLabel.textColor = [UIColor lightGrayColor];
    blankViewLabel.shadowOffset = CGSizeMake(0, 1);
    blankViewLabel.backgroundColor = [UIColor clearColor];
    blankViewLabel.textAlignment = NSTextAlignmentCenter;
    blankViewLabel.text = text;
    blankViewLabel.tag = 1;
    
    //add label to view
    [blankView addSubview:blankViewLabel];
    
    //hide the view
    blankView.hidden = YES;
    
    return blankView;
}

@end