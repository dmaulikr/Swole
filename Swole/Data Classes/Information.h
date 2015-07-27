//
//  Information.h
//  Swole
//
//  Created by gamaux01 on 2015/6/24.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Information : NSObject <NSCoding>

@property NSNumber *weight;
@property NSNumber *reps;

- (instancetype)initSetWithWeight:(float)weight reps:(NSInteger)reps;


@end
