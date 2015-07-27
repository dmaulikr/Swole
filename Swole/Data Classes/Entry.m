//
//  Entry.m
//  Swole
//
//  Created by gamaux01 on 2015/6/24.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "Entry.h"

@implementation Entry

//creates an entry given a routine name and date
- (instancetype) initWithEntryName:(NSString *)entryName date:(NSString *)dateStr units:(SystemOfMeasurement)systemOfMeasurement{
    self = [super init];
    if (self) {
        _lastSystem = systemOfMeasurement;
        _entryName = entryName;
        _dateStr = dateStr;
        _exerciseNames = [[NSMutableArray alloc] initWithObjects: nil];
        _exercises = [[NSMutableDictionary alloc] initWithObjectsAndKeys: nil];
        [self processStringToNSDate:_dateStr];
    }
    return self;
}

#pragma mark - Conversion

//edited
- (void) convertTo:(SystemOfMeasurement) newSystem {
    if (newSystem == IMPERIAL) {
        for (NSString* exerciseName in _exerciseNames) {
            for (Information *info in _exercises[exerciseName]) {
                info.weight = [NSNumber numberWithFloat: [info.weight floatValue] * 2.2f];
            }
        }
    } else if (newSystem == METRIC) {
        for (NSString* exerciseName in _exerciseNames) {
            for (Information *info in _exercises[exerciseName]) {
                info.weight = [NSNumber numberWithFloat: [info.weight floatValue] / 2.2f];
            }
        }
    }
}

#pragma mark - Dates

- (void) processStringToNSDate:(NSString *)dateStr {
    // Convert string (e.g. 2015-6-24) to date object (according to NSDateFormatter formatting strings reference)
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    _date = date;
}

- (void) processNSDateToNSDateComponents:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    _year = [components year];
    _month = [components month];
    _day = [components day];
    
}

#pragma mark - Adding and deleting exercises and information

- (void) deleteExerciseWithName:(NSString *)name {
    [_exerciseNames removeObject:name];
    [_exercises removeObjectForKey:name];
}

//edited into info array
- (void) addExerciseWithName:(NSString *)name {
    if (!([self.exerciseNames containsObject:name])) {
        [self.exerciseNames addObject:name];
        [self.exercises setObject: [[NSMutableArray alloc] initWithObjects: nil] forKey:name];
    }
}

- (void) addExerciseWithName:(NSString *)name Info:(Information *)info {
    NSMutableArray *infoArray;
    if ([_exerciseNames containsObject:name]) {//has name, so old entry, simply insert
        infoArray = _exercises[name];
        [infoArray addObject: info];
    } else {//new entry
        [_exerciseNames addObject:name];
        infoArray = [[NSMutableArray alloc] initWithObjects:info, nil];
        [_exercises setValue:infoArray forKey:name];
    }
}

- (void) deleteInformationAtIndex:(NSUInteger)index FromExercise:(NSString *)name {
    NSMutableArray *infoArray = _exercises[name];
    [infoArray removeObjectAtIndex:index];
    if ([infoArray count] == 0) {
        [_exercises removeObjectForKey:name];
        [_exerciseNames removeObject:name];
    }
}

- (NSUInteger) count {
    return [_exerciseNames count];
}

#pragma mark - NSCoder
- (void)encodeWithCoder:(NSCoder *)coder; //freeze
{
    [coder encodeObject:_exercises forKey:@"exercises"];
    [coder encodeObject:_exerciseNames forKey:@"exerciseNames"];
    [coder encodeObject:_entryName forKey:@"entryName"];
    [coder encodeInteger:_lastSystem forKey:@"lastSystem"];


    [coder encodeObject:_dateStr forKey:@"dateStr"];
    [coder encodeObject:_date forKey:@"date"];
    [coder encodeInteger:_year forKey:@"year"];
    [coder encodeInteger:_month forKey:@"month"];
    [coder encodeInteger:_day forKey:@"day"];
}

- (id)initWithCoder:(NSCoder *)coder; //un-freeze
{
    self = [[Entry alloc] init];
    if (self != nil)
    {
        _exercises = [coder decodeObjectForKey:@"exercises"];
        _exerciseNames = [coder decodeObjectForKey:@"exerciseNames"];
        _entryName = [coder decodeObjectForKey:@"entryName"];
        _lastSystem = [coder decodeIntegerForKey:@"lastSystem"];
        
        _dateStr = [coder decodeObjectForKey:@"dateStr"];
        _date = [coder decodeObjectForKey:@"date"];
        _year = [coder decodeIntegerForKey:@"year"];
        _month = [coder decodeIntegerForKey:@"month"];
        _day = [coder decodeIntegerForKey:@"day"];
    }
    return self;
}

@end
