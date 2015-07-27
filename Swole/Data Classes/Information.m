//
//  Information.m
//  Swole
//
//  Created by gamaux01 on 2015/6/24.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "Information.h"

/**
 * Contains information regarding a certain exercise.
 */

@implementation Information

- (instancetype) initSetWithWeight:(float)weight reps:(NSInteger)reps {
    self = [super init];
    if (self) {
        self.weight = [NSNumber numberWithFloat:weight];
        self.reps = [NSNumber numberWithFloat:reps];

    }
    return self;
}

#pragma mark - NSCoder
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.weight forKey:@"weight"];
    [coder encodeObject:self.reps forKey:@"reps"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[Information alloc] init];
    if (self != nil)
    {
        self.weight = [coder decodeObjectForKey:@"weight"];
        self.reps = [coder decodeObjectForKey:@"reps"];
    }
    return self;
}

@end
