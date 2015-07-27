//
//  SpringTableViewCell.m
//  Swole
//
//  Created by gamaux01 on 2015/7/16.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "SpringTableViewCell.h"

@implementation SpringTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.mainLabel.backgroundColor = [UIColor clearColor];
    self.mainLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
