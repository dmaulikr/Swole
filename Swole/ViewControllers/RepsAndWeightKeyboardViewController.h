//
//  RepsAndWeightKeyboardViewController.h
//  Swole
//
//  Created by gamaux01 on 2015/7/21.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

/**
 *  Provides an interface to add a set to a selected exercise.
 */

#import <UIKit/UIKit.h>
#import "AddExerciseAlertViewController2.h"
#import "Swole-Swift.h"

@interface RepsAndWeightKeyboardViewController : UIViewController

/**
 *  Views.
 */
@property UITextField *repsField;
@property UITextField *weightField;
@property UILabel *xLabel;
@property UILabel *unitLabel;
@property SpringButton *checkedButton;

@property id <EntryViewController2Delegate> entryViewController2Delegate; //used to pass an Information object

- (void) loadAllViews;

/**
 *  Button Actions.
 */
- (Information *) returnInfoFromFields;
- (void) pop:(id)sender; //animation


@end
