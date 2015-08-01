//
//  EntryCellData.h
//  Swole
//
//  Created by gamaux01 on 2015/7/20.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

typedef NS_ENUM(NSInteger, EntryCellDataType) {
    DESCRIPTION, //describes the Entry
    EXERCISE, //describes an exercise
    INFORMATION //describes reps and weight
};

@interface EntryCellData : NSObject

@property EntryCellDataType type;
@property NSDictionary *attributes;

- (instancetype) initDescriptionWithAttributes:(NSDictionary *)attributes;
- (instancetype) initExerciseWithAttributes:(NSDictionary *)attributes;
- (instancetype) initInformationWithAttributes:(NSDictionary *)attributes;

+ (NSUInteger) countHidden:(NSArray *)dataArray;
+ (NSArray *)hideInfoOfExercise:(EntryCellData *)exercise InDataArray:(NSArray *)dataArray;

/**
 *  Given an Entry object, produces an array of EntryCellData that can be
 *  easily parsed and converted into UITableViewCells.
 *
 *  @param entry Entry to be displayed as UITableView
 *
 *  @return NSArray of EntryCellData that represents the entry
 */
+ (NSArray *) convertEntryToEntryCellDataArray: (Entry *)entry;

@end