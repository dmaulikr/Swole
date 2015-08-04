//
//  EntryCellData.m
//  Swole
//
//  Created by gamaux01 on 2015/7/20.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "EntryCellData.h"

@implementation EntryCellData

- (instancetype) initDescriptionWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.type = DESCRIPTION;
        self.attributes = attributes;
    }
    return self;
}

- (instancetype) initExerciseWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.type = EXERCISE;
        self.attributes = attributes;
    }
    return self;
}

- (instancetype) initInformationWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.type = INFORMATION;
        self.attributes = attributes;
    }
    return self;
}

/**
 *  Returns the number of visible items in an array.
 *
 *  @param dataArray array
 *
 *  @return number of visible items in array given
 */
+ (NSUInteger) countHidden:(NSArray *)dataArray {
    int numHidden = 0;
    for (EntryCellData *entryCellData in dataArray) {
        if (entryCellData.type == INFORMATION) {
            BOOL hidden = [entryCellData.attributes[@"Hidden"] boolValue];
            if (hidden) {
                numHidden++;
            }
        }
    }
    return numHidden;
}


/**
 *  Given a data array and a selected exercise,
 *  returns an array with two items:
 *  the original array with corresponding INFORMATION objects with the HIDDEN attribute set to YES,
 *  and an array without those INFORMATION.
 *
 *  @param exercise  selected exercise
 *  @param dataArray data for a given entry
 *
 *  @return data array with information for the selected exercise hidden
 */

+ (NSArray *) modifyInfoOfExercise:(EntryCellData *)exercise InDataArray:(NSArray *)dataArray  Hide:(BOOL)hide {
    NSMutableArray *arrayWithHiddenObjects = [[NSMutableArray alloc] initWithObjects: nil];
    NSMutableArray *arrayWithoutHiddenObjects = [[NSMutableArray alloc] initWithObjects: nil];
    
    int indexOfDataArray = 0;
    while (![dataArray[indexOfDataArray] isEqual: exercise]) {//add all data up until the selected exercise
        [arrayWithHiddenObjects addObject:dataArray[indexOfDataArray]];
        indexOfDataArray++;
    }
    
    EntryCellData *entryCellData = dataArray[indexOfDataArray]; //modify the exercise to either hidden (collapsed) or not hidden (expanded)
    NSMutableDictionary *exerciseAttributes = [entryCellData.attributes mutableCopy];
    [exerciseAttributes setValue:[NSNumber numberWithBool:hide] forKey:@"Hidden"];
    entryCellData.attributes = [exerciseAttributes copy];
    
    [arrayWithHiddenObjects addObject:dataArray[indexOfDataArray]]; // add the selected exercise
    indexOfDataArray++;
    
    if (indexOfDataArray < [dataArray count]) { //if any data comes after
        entryCellData = dataArray[indexOfDataArray];
    }
    while (indexOfDataArray < [dataArray count] && entryCellData.type == INFORMATION) {//and its of INFORMATION type, process them
        entryCellData = dataArray[indexOfDataArray];
        NSMutableDictionary *infoAttributes = [entryCellData.attributes mutableCopy];
        [infoAttributes setValue:[NSNumber numberWithBool:hide] forKey:@"Hidden"];
        entryCellData.attributes = [infoAttributes copy];
        [arrayWithHiddenObjects addObject:entryCellData];
        indexOfDataArray++;
    }
    
    while (indexOfDataArray < [dataArray count]) {//then add everything else
        [arrayWithHiddenObjects addObject:dataArray[indexOfDataArray]];
        indexOfDataArray++;
    }
    
    //add only items that aren't hidden
    for (EntryCellData *entryCellData in arrayWithHiddenObjects) {
        if (!(entryCellData.type == INFORMATION && [entryCellData.attributes[@"Hidden"] boolValue] == YES)) {
            [arrayWithoutHiddenObjects addObject:entryCellData];
        }
    }
    
    return [[NSArray alloc] initWithObjects: [arrayWithHiddenObjects copy], [arrayWithoutHiddenObjects copy], nil];
}

+ (NSArray *)convertEntryToEntryCellDataArray:(Entry *)entry {
    NSMutableArray *cellDataArray = [[NSMutableArray alloc] initWithObjects: nil];
    
    //Process description
    NSDictionary *descriptionAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: entry.dateStr, @"Date String", entry.entryName, @"Entry Name", nil];
    
    EntryCellData *descriptionCellData = [[EntryCellData alloc] initDescriptionWithAttributes: descriptionAttributes];
    
    [cellDataArray addObject: descriptionCellData];
    
    //Get relevant fields from entry object
    NSMutableArray *exerciseNames = [entry exerciseNames];
    NSMutableDictionary *exercises = [entry exercises];
    
    //Allocate space for objects
    NSDictionary *exerciseAttributes;
    NSDictionary *informationAttributes;
    EntryCellData *exerciseCellData;
    EntryCellData *infoCellData;
    
    int setNumber;
    
    //Process exercises
    for (NSString *exerciseName in exerciseNames) {
        setNumber = 1;
        exerciseAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: exerciseName, @"Exercise Name", @"Expanded", @"State", nil];
        exerciseCellData = [[EntryCellData alloc] initExerciseWithAttributes: exerciseAttributes];
        [cellDataArray addObject: exerciseCellData];
        
        //starting location
        
        //Process individual exercises
        NSMutableArray *infoArray = exercises[exerciseName];
        for (Information *info in infoArray) {
            informationAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: info.reps, @"Reps", info.weight, @"Weight", exerciseName, @"Parent Exercise Name", [NSNumber numberWithInt:setNumber], @"Set Number", [NSNumber numberWithBool:NO], @"Hidden", nil];
            infoCellData = [[EntryCellData alloc] initInformationWithAttributes:informationAttributes];
            [cellDataArray addObject:infoCellData];
            setNumber++;
        }
    }
    
    return [cellDataArray copy];
    
}

@end
