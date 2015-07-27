//
//  EntryList.m
//  Swole
//
//  Created by gamaux01 on 2015/6/24.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "EntryList.h"

@implementation EntryList

- (instancetype) init {
    self = [super init];
    if (self) {
        _dates = [[NSMutableArray alloc] initWithObjects:nil];
        _entries = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
        _entriesByEntryName = [[NSMutableDictionary alloc] initWithObjectsAndKeys: nil];
        _defaultSystemOfMeasurement = METRIC; //defaults to METRIC system
    }
    return self;
}

- (NSUInteger) count {
    return [_dates count];
}

#pragma mark - Toggling the system of measurement

- (void) toggleSystem {
    if (_defaultSystemOfMeasurement == METRIC) {
        _defaultSystemOfMeasurement = IMPERIAL;
    } else if (_defaultSystemOfMeasurement == IMPERIAL) {
        _defaultSystemOfMeasurement = METRIC;
    }
}

#pragma mark - Modifying the entries NSMutableDictionary

- (void)addEntry:(Entry *)entry date:(NSString *)date {
    [entry setDateStr: date];
    if (![_dates containsObject:date]) {
        [_dates addObject:date];
    }
    [_entries setObject:entry forKey:date];
}

- (Entry *)getEntry:(NSString *)key {
    return _entries[key];
}

- (void)deleteEntry:(NSString *)date {
    [_entries removeObjectForKey:date];
    [_dates removeObject:date];
}

- (void) addDateToEntriesByEntryName:(NSString *)entryName Date:(NSString *) dateStr{
    NSMutableArray *dateStrArray;
    if (![_entriesByEntryName objectForKey:entryName]) { // if nil, initialize mutablearray
        dateStrArray = [[NSMutableArray alloc] initWithObjects:dateStr, nil];
        [_entriesByEntryName setObject:dateStrArray forKey:entryName];
    } else {
        dateStrArray = _entriesByEntryName[entryName];
        [dateStrArray insertObject:dateStr atIndex:0];
    }
}

- (void) deleteDateFromEntriesByEntryName:(NSString *)entryName Date:(NSString *) dateStr{
    NSMutableArray *dateStrArray;
    if ([_entriesByEntryName objectForKey:entryName]) {
        dateStrArray = _entriesByEntryName[entryName];
        [dateStrArray removeObject:dateStr];
    }
}


#pragma mark - NSCoder
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_dates forKey:@"dates"];
    [coder encodeObject:_entries forKey:@"entries"];
    [coder encodeObject:_entriesByEntryName forKey:@"entriesByEntryName"];
    [coder encodeInteger:_defaultSystemOfMeasurement forKey:@"defaultSystemOfMeasurement"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[EntryList alloc] init];
    if (self != nil)
    {
        _dates = [coder decodeObjectForKey:@"dates"];
        _entries = [coder decodeObjectForKey:@"entries"];
        _entriesByEntryName = [coder decodeObjectForKey:@"entriesByEntryName"];
        _defaultSystemOfMeasurement = [coder decodeIntegerForKey:@"defaultSystemOfMeasurement"];
    }
    return self;
}


@end
