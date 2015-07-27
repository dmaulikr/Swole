//
//  SpringTableViewCell.h
//  Swole
//
//  Created by gamaux01 on 2015/7/16.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Swole-Swift.h"

@interface SpringTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SpringLabel* mainLabel;
@property NSString *date;

@end
