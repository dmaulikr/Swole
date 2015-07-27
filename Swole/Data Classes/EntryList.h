///
/// Swole
/// EntryList.h
/// Copyright (c) 2015 Victor Lin
///

#import <Foundation/Foundation.h>
#import "Entry.h"

/**
 * 'EntryList' is Swole's root object for storing user input data.
 *  Use it to store, modify, and look up 'Entry' objects, as well as 
 *  to get the current system of measurement.
 */

@interface EntryList : NSObject <NSCoding>

/**
 *  Array of date strings that are keys for 'Entry' objects.
 */

@property NSMutableArray *dates; //todo: find a way to sort these dates, I'm thinking by using the date field in the respective Entry, using descriptors

/**
 *  Maps date string to the 'Entry' object that was created on that date. dateStr -> Entry
 */

@property NSMutableDictionary *entries;

/**
 *  Maps entryName string to an array of date strings. entryName -> dateStrings
 *  These specific dates contain entries that of entryName.
 */

@property NSMutableDictionary *entriesByEntryName;

/**
 *  The global system of measurement used.
 */

@property SystemOfMeasurement defaultSystemOfMeasurement;

/**
 *  Initializes an EntryList object with empty arrays and dictionaries
 *  and sets the defaultSystemOfMeasurement to the METRIC SYSTEM.
 *
 *  @return initialized EntryList object
 */

- (instancetype) init;

- (void) addDateToEntriesByEntryName:(NSString *)entryName Date:(NSString *) dateStr; // entryName -> array of dateStr

- (void) deleteDateFromEntriesByEntryName:(NSString *)entryName Date:(NSString *) dateStr;

- (NSUInteger) count;

- (void) toggleSystem;

- (void)addEntry:(Entry *)entry date:(NSString *)date;

- (Entry *)getEntry:(NSString *)key;

- (void)deleteEntry:(NSString *)date;


@end
