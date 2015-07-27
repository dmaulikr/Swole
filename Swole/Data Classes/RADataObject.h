//
//Copyright (c) 2013 Rafał Augustyniak, 2015 Victor Lin
//
//

#import <Foundation/Foundation.h>
#import "Entry.h"

typedef NS_ENUM(NSInteger, TypeOfRADataObject) {
    DESCRIPTION,
    EXERCISE,
    INFORMATION
};

@interface RADataObject : NSObject

@property TypeOfRADataObject RADataObjectType;
@property (strong, nonatomic) NSString *name;
@property NSString *dateStr;
@property (strong, nonatomic) NSMutableArray *infoArray;
@property int reps;
@property int sets;
@property float weight;

- (instancetype)initInformationForExercise:(NSString *)exerciseName WithWeight:(float) weight reps:(int)reps sets:(int)sets; //INFORMATION

- (instancetype)initSetsWithName:(NSString *)name infoArray:(NSArray *)infoArray; //EXERCISE

- (instancetype)initDescriptionWithName:(NSString *)name dateStr:(NSString *)dateStr; //DESCRIPTION

@end
