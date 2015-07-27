//
//  Entry.h
//  Swole
//
//  Created by gamaux01 on 2015/6/24.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Information.h"

@interface Entry : NSObject <NSCoding>

typedef NS_ENUM(NSInteger, SystemOfMeasurement)
{
    METRIC,
    IMPERIAL
};

@property NSMutableDictionary *exercises; //exerciseName -> information NSMutableArray
@property NSMutableArray *exerciseNames; //exercises under this entry
@property NSString *entryName; //routine name
@property SystemOfMeasurement lastSystem; //crucial for maintaining weight consistency

/**
 *  Time.
 */
@property NSString *dateStr;
@property NSDate *date;
@property NSInteger year;
@property NSInteger month;
@property NSInteger day;

- (instancetype) initWithEntryName:(NSString *)entryName date:(NSString *)dateStr units:(SystemOfMeasurement)systemOfMeasurement;

/**
 *  Converts the value of the weights to fit the new system of measurement.
 *
 *  @param newSystem the new system of measurement.
 */
- (void) convertTo:(SystemOfMeasurement) newSystem;

- (void) addExerciseWithName:(NSString *)name;

- (void) addExerciseWithName:(NSString *)name Info:(Information *)info;//use this to add information

- (void) deleteExerciseWithName:(NSString *)name;

- (void) deleteInformationAtIndex:(NSUInteger)index FromExercise:(NSString *)name;

- (NSUInteger) count;

@end
