//
//  EntryViewController2.h
//  Swole
//
//  Created by gamaux01 on 2015/7/20.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

/**
 * Allows you to see and interact with the collection of exercises with
 * a particular date.
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Entry.h"
#import "CustomIOSAlertView.h"
#import "AddExerciseAlertViewController2.h"
#import "AddEntryAlertViewController.h"
#import "RepsAndWeightKeyboardViewController.h"

@interface EntryViewController2 : UIViewController <UITableViewDataSource, UITableViewDelegate, EntryViewController2Delegate>


- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithEntry:(Entry *)entry; //EntryViewController2 must be instantiated with an entry

/**
 *  Views.
 */
@property (weak, nonatomic) IBOutlet UITableView *entryTableView;
@property UIBarButtonItem *createExerciseBarButton;
@property CustomIOSAlertView *exerciseAlertView; //save the pointer for dismissal
@property AddExerciseAlertViewController2 *addExerciseAlertViewController2; //don't want the controller to deallocate when we need it
@property RepsAndWeightKeyboardViewController *repsAndWeightKeyboardViewController;

/**
 *  Delegates.
 */
@property (nonatomic, assign) id <EntryListViewControllerDelegate> entryListViewControllerDelegate; //adding and deleting data

/**
 *  Model.
 */
@property Entry *entry;
@property NSArray *data; //an array of cellDataObjects corresponding to each cell in entryTableView
@property NSMutableArray *exerciseNames;
@property NSMutableDictionary *exercises;
@property NSString *currentExercise;
@property NSIndexPath *currentExerciseCellIndexPath;
@property NSIndexPath *lastSelectedCellIndexPath;
@property NSUInteger numberHidden;
@property BOOL shouldOffsetByNumberHidden;

/**
 *  Methods that help set-up.
 */
- (void) loadData; //populates the data array that provides context for entryTableView.
- (void) loadFrames;
- (void) loadFontAttributes;
- (void) loadFooterView;
- (void) loadCreateExerciseBarButton;

/**
 *  Resizing.
 */
- (void) resizeEntryTableView;

/**
 *  Animations.
 */

- (void) slideRepsAndWeightKeyboardIn;
- (void) slideRepsAndWeightKeyboardOut;
- (void) animateReloadForTable:(UITableView *)table;

@end
