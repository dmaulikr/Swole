//
//  EntryViewController.h
//  Swole
//
//  Created by gamaux01 on 2015/6/18.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddExerciseAlertViewController.h"
#import "AddEntryAlertViewController.h"
#import "FRDLivelyButton.h"
#import "UIElementHelper.h"
#import "CustomIOSAlertView.h"
#import "Entry.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "RATableViewCell.h"
#import "DataElementHelper.h"
#import "FRDLivelyButton.h"
#import "AnalysisViewController.h"

@protocol UserDefaultDelegate <NSObject>

@required
- (void) saveToUserDefaults;
@end

@interface EntryViewController : UIViewController <AddExerciseDelegate, RATreeViewDataSource, RATreeViewDelegate> {
    NSString *_unit;
}

//Tree view properties.

@property RATreeView *treeView;
@property (strong, nonatomic) NSMutableArray *data;
@property RATableViewCell *cellWithFocus;


//Data properties.

@property NSString *exerciseName; //exercise clicked
@property NSMutableArray *exerciseNames;
@property NSMutableDictionary *exercises;
@property Entry *entry;

//Buttons.

@property UIBarButtonItem *systemOfMeasurementBButton;
@property UIBarButtonItem *addExerciseBarButton;
@property UIBarButtonItem *analysisButton;

//Views.

@property CustomIOSAlertView *exerciseAlertView; //below exercise alert view controller
@property AddExerciseAlertViewController *addExerciseAlertViewController;

//Delegates

@property (nonatomic, assign) id <EntryListViewControllerDelegate> entryListViewControllerDelegate;

- (void)showAnalysisView;

///**
// *  Toggles the system of measurement at the 'EntryList' level,
// *  then calls toggleSystemOfMeasurement if the table is present
// *  or toggleSystemOfMeasurementAndUpdateTable if it isn't.
// *
// *  Updates the kg/lb button.
// */
//
//- (void)toggleSystem;
//
///**
// *  Converts 'Entry' values to the current system of measurement.
// *  Updates the text for the gray 'No Exercises' view.
// */
//
//- (void)toggleSystemOfMeasurement;
//
///**
// * Converts 'Entry' values to the current system of measurement.
// * Updates the tree view.
// */
//
//- (void)toggleSystemOfMeasurementAndUpdateTable;

@end
