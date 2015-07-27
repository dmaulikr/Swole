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

    //work in progress - for collapsing cells
//    NSMutableDictionary *infoRangeDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: nil]; //will be placed in the last index, a dictionary that maps the exercises to the range of its associated information's first and last index, used for expanding and collapsing cells
//    
//    NSRange infoRange;
//    NSUInteger loc;
//    NSUInteger len;
    
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
            informationAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: info.reps, @"Reps", info.weight, @"Weight", exerciseName, @"Parent Exercise Name", [NSNumber numberWithInt:setNumber], @"Set Number", nil];
            infoCellData = [[EntryCellData alloc] initInformationWithAttributes:informationAttributes];
            [cellDataArray addObject:infoCellData];
            setNumber++;
        }
    }
    
    return [cellDataArray copy];
    
}

@end
