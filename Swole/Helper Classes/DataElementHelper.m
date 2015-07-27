//
//  DataElementHelper.m
//  Swole
//
//  Created by Victor on 7/4/15.
//  Copyright (c) 2015 Victor's Personal Projects. All rights reserved.
//

#import "DataElementHelper.h"

@implementation DataElementHelper


+ (NSMutableArray *)convertEntryToDataArray:(Entry *)entry {
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithObjects: nil];
    
//    RADataObject *description = [[RADataObject alloc] initDescriptionWithName: [entry entryName] dateStr:[entry dateStr]];
//    dataArray = [NSMutableArray arrayWithObject:description];
//    
//    NSMutableDictionary *exercises = [entry exercises];
//    NSMutableArray *exerciseNames = [entry exerciseNames];
//    
//    RADataObject *RAExercise;
//    
//    for (NSString *exerciseName in exerciseNames) {//get an exercise
//        NSMutableArray *infoArray = exercises[exerciseName];//get its info
//        if ([infoArray count] > 0) {
//            RADataObject *RAInfo;
//            NSMutableArray *RAInfoArray = [[NSMutableArray alloc] initWithObjects: nil];
//            
//            for (Information *info in infoArray) {//convert info to RAInfo
//                RAInfo = [[RADataObject alloc] initInformationForExercise: exerciseName WithWeight:info.weight reps:info.reps sets:info.sets];
//                [RAInfoArray addObject:RAInfo];
//            }
//            RAExercise = [[RADataObject alloc] initSetsWithName:exerciseName infoArray:RAInfoArray];
//            [dataArray addObject:RAExercise];
//
//        }
//    }
    return dataArray;
}

+ (NSMutableArray *)returnWeightBreakthroughDatesAndValuesForExercise:(NSString *)exerciseName InEntryList:(EntryList *)entryList {
    int numRecords = 0; //we only keep track of the top 5
    int indexOfWeightArray; //tracks position for array of weight values for the exercise on a given day
    NSNumber *max = [[NSNumber alloc] initWithFloat:0.f];

    SystemOfMeasurement currentMeasurement = [entryList defaultSystemOfMeasurement];
    NSMutableArray *allDates = [entryList dates];
    NSMutableArray *dates = [[NSMutableArray alloc] initWithObjects:nil];    //the array of dates of routines containing the specified exercise
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:nil];    //the array of info arrays with indices respective to the array of dates
    NSMutableArray *datesAndValues = [[NSMutableArray alloc] initWithObjects: nil];     //the top five breakthrough dates and the exercise, in decreasing order
    NSMutableArray *entriesWithExercise = [[NSMutableArray alloc] initWithObjects: nil]; //the array to be placed in the last index
    
    NSMutableDictionary *entries = [entryList entries];
    
    Entry *entry;
    SystemOfMeasurement lastMeasurement;
    NSMutableArray *exerciseNames;
    NSMutableDictionary *exercises;
    
    for (NSString *date in allDates) {//go through all the dates/entries

        //get the entry
        entry = entries[date];
        
        //get the exercises of the particular entry
        exerciseNames = [entry exerciseNames];
        exercises = [entry exercises];
        
        if ([exerciseNames containsObject:exerciseName]) {//if the entry has the exercise we want,
            [entriesWithExercise addObject: entry];
            //conversion to correct value
            lastMeasurement = [entry lastSystem];
            if (lastMeasurement != currentMeasurement) {
                [entry convertTo:currentMeasurement];
                [entry setLastSystem:currentMeasurement];
                lastMeasurement = currentMeasurement;
            }
            
            indexOfWeightArray = 0; //restart the index
            NSMutableArray *infoArray = exercises[exerciseName];
            NSMutableArray *weightArray = [[NSMutableArray alloc] initWithObjects: nil];
            for (Information *info in infoArray) { //extract the weight information
                [weightArray addObject: info.weight];
            }
            
            //order weights from highest to lowest
            NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
            [weightArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
            
            //update our existing value array with the weight array.
            //add when the max has been surpassed
            while (indexOfWeightArray < [weightArray count] && [max floatValue] < [weightArray[indexOfWeightArray] floatValue]) {
                max = weightArray[indexOfWeightArray];
                if (numRecords >= 5) { //if we have five records
                    [dates removeObjectAtIndex:4]; //remove the last object
                    [values removeObjectAtIndex:4];
                } else {
                    numRecords++;
                }
                [dates addObject:date]; //always add the new max
                [values addObject:max];
                indexOfWeightArray++;
            }
        }
    }
    
    //merging
    for (int i = 0; i < [dates count]; i++) {
        [datesAndValues insertObject:dates[i] atIndex: 2*i];
        [datesAndValues insertObject:values[i] atIndex: 2*i+1];
    }
    [datesAndValues addObject: entriesWithExercise];
    
    return datesAndValues;
}

+ (NSArray *)returnWeightBreakthroughAnalysisForExercise:(NSString *)exerciseName Weight:(float)weight InEntryArray:(NSMutableArray *)entriesWithExercise {
    
    //to return
    NSString *firstDate;
    NSString *lastDate;
    NSString *maxSingleRepDate;
    NSString *maxNumberOfRepsOneDayDate;
    NSNumber* numDays = [[NSNumber alloc] initWithInt:0];
    NSNumber* maxSingleRep = [[NSNumber alloc] initWithInt:0];
    NSNumber* maxNumberOfRepsOneDay = [[NSNumber alloc] initWithInt:0];
    
    //convenience
    BOOL containsExercise;
    int numberOfRepsDay; //stores number of reps done for the exercise during the selected day
    
    for (Entry *entry in entriesWithExercise) {//go through every entry
        numberOfRepsDay = 0;
        containsExercise = NO;
        NSDictionary *exercises = [entry exercises];
        NSMutableArray *infoArray = exercises[exerciseName]; //extract the proper info
        
        for (Information *info in infoArray) {
            if ( (int) info.weight == (int) weight) {//if it has the proper weight
                //max single rep operations
                if ([info.reps intValue] > [maxSingleRep intValue]) {
                    maxSingleRep = info.reps;
                    maxSingleRepDate = [entry dateStr];
                }
                numberOfRepsDay += [info.reps intValue];
                containsExercise = YES;
            }
        }
        
        if (containsExercise) {
            if ([numDays intValue] == 0) {//first entry with exercise, assuming the entries are pre-sorted by date
                firstDate = [entry dateStr];//set this once
            }
            lastDate = [entry dateStr];//always set this
            numDays = [[NSNumber alloc] initWithInt:[numDays intValue] + 1];
        }
        
        if (numberOfRepsDay > [maxNumberOfRepsOneDay intValue]) {
            maxNumberOfRepsOneDay = [[NSNumber alloc] initWithInt: numberOfRepsDay];
            maxNumberOfRepsOneDayDate = [entry dateStr];
        }
        containsExercise = NO;
    }
    
    NSArray *returnArray = [[NSArray alloc] initWithObjects: firstDate, lastDate, numDays, maxSingleRep, maxSingleRepDate, maxNumberOfRepsOneDay, maxNumberOfRepsOneDayDate, nil];
    
    return returnArray;
}

+ (NSMutableArray *)sortEntriesByDate:(NSMutableArray *)entryArray {
    NSSortDescriptor *entryDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending: YES];
    NSArray *sortDescriptors = @[entryDateDescriptor];
    NSArray *resultArray = [entryArray sortedArrayUsingDescriptors:sortDescriptors];
    return [resultArray mutableCopy];
}

+ (NSMutableArray *)updateDateStrings:(NSMutableArray *) dateStringMutableArray WithEntryArray:(NSMutableArray *)entryArray {
    NSMutableArray *sortedEntryArray = [DataElementHelper sortEntriesByDate:entryArray];
    for (int i = 0; i < [sortedEntryArray count]; i++) {
        dateStringMutableArray[i] = [sortedEntryArray[i] dateStr];
    }
    return dateStringMutableArray;
}

+ (BOOL) isDateA: (NSDate *)dateA EqualToDateB: (NSDate *)dateB {
    NSDateComponents *dateAComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate: dateA];
    NSDateComponents *dateBComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate: dateB];
    return [dateAComponents isEqual:dateBComponents];
}

+ (NSString *) dateToString: (NSDate *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

+ (NSDate *) stringToDate: (NSString *) string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter dateFromString:string];
}

@end