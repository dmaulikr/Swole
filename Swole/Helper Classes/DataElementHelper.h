//
//  DataElementHelper.h
//  Swole
//
//  Created by Victor on 7/4/15.
//  Copyright (c) 2015 Victor's Personal Projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RADataObject.h"
#import "EntryList.h"

@interface DataElementHelper : NSObject

/**
 *  Converts an 'Entry' object to a NSMutableArray containing 'RADataObject's
 *  for the tree view. At the zeroth index is the DESCRIPTION RADataObject of the 'Entry',
 *  while the succeeding indices hold EXERCISE RADataObjects.
 *
 *  @param entry 'Entry' to display in the tree view
 *
 *  @return Data array representing the 'Entry'
 */
+ (NSMutableArray *) convertEntryToDataArray:(Entry *)entry;

/**
 *  Given an exercise, returns up to the first five weight breakthrough dates
 *  and corresponding weights for it. The date and value will be paired in
 *  index location i and i + 1. The last location will contain an array of all the
 *  'Entry's containing the exercise.
 *
 *  @param exerciseName name of the exercise
 *  @param entryList    entry list containing the exercise
 *
 *  @return NSArray containing breakthrough dates and values, and an array contain all the entries containing the exercise
 */
+ (NSMutableArray *)returnWeightBreakthroughDatesAndValuesForExercise:(NSString *)exerciseName InEntryList:(EntryList *)entryList;

/**
 *  Returns an array of miscellaneous information about the exercise done at a certain weight.
 *  Index 0: first date
 *  Index 1: most current date
 *  Index 2: number of days you have exercised at this weight
 *  Index 3: max single rep
 *  Index 4: date for above
 *  Index 5: max number of reps in a set
 *  Index 6: date for above
 *
 *  @param exerciseName the name of the exercise
 *  @param weight the weight of the exercise
 *  @param entriesWithExercise an array containing all the relevant entries
 *
 *  @return array of analytic information
 */
+ (NSArray *)returnWeightBreakthroughAnalysisForExercise:(NSString *)exerciseName Weight:(float)weight InEntryArray:(NSMutableArray *)entriesWithExercise;


+ (NSMutableArray *)sortEntriesByDate:(NSMutableArray *)entryArray;

+ (NSMutableArray *)updateDateStrings:(NSMutableArray *) dateStringMutableArray WithEntryArray:(NSMutableArray *)entryArray;

+ (BOOL) isDateA: (NSDate *)A EqualToDateB: (NSDate *)B;

+ (NSString *) dateToString: (NSDate *) date;

+ (NSDate *) stringToDate: (NSString *) string;

@end
