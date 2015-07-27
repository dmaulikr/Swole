//
//Copyright (c) 2014 Rafał Augustyniak, 2015 Victor Lin
//

#import "RADataObject.h"


@implementation RADataObject

- (instancetype)initInformationForExercise:(NSString *)exerciseName WithWeight:(float) weight reps:(int)reps sets:(int)sets {
    self = [super init];
    if (self) {
        _name = exerciseName;
        _weight = weight;
        _reps = reps;
        _sets = sets;
        _RADataObjectType = INFORMATION;
    }
    return self;
}//INFORMATION

- (instancetype)initSetsWithName:(NSString *)exerciseName infoArray:(NSMutableArray *)infoArray {
    self = [super init];
    if (self) {
        _name = exerciseName;
        _infoArray = infoArray;
        if (_infoArray == nil || [_infoArray count] == 0) {
            [NSException raise:@"Invalid information" format:@"Invalid information for %@!", _name];
        } else if ([_infoArray count] >= 1) {
            _RADataObjectType = EXERCISE;
        }
    }
    return self;
}//EXERCISE

- (instancetype)initDescriptionWithName:(NSString *)name dateStr:(NSString *) dateStr{
    self = [super init];
    if (self) {
        _dateStr = dateStr;
        _name = name;
        _RADataObjectType = DESCRIPTION;
    }
    return self;
}//DESCRIPTION



@end
