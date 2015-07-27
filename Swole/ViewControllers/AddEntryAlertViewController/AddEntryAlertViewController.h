//
//  AddEntryAlertViewController.h
//  Swole
//
//  Created by gamaux01 on 2015/6/22.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIElementHelper.h"
#import "RPFloatingPlaceholderTextField.h"
#import "EntryList.h"
#import <QuartzCore/QuartzCore.h>


/**
 *  Controls all the interactions with the master view controller.
 */

@protocol EntryListViewControllerDelegate <NSObject>

/**
 *  Calendar.
 */

- (void) animateEntryListViewLabels;
- (void) doCellButton; //after selecting a cell in calendar, it becomes a button, and this is its action

/**
 *  EntryList.
 */

- (void) addAndSaveEntry:(Entry *)entry date:(NSString *)date;
- (void) deleteAndSaveEntryWithDate:(NSString *)date;

/**
 *  User defaults.
 */

- (void) loadFromUserDefaults;
- (void) saveToUserDefaults;

/**
 *  Add Exercise Alert View
 */

- (void) dismissExerciseAlertView;
- (void) addEntryToEntryList:(Entry *)entry;


- (EntryList *) getEntryList;
- (SystemOfMeasurement) systemOfMeasurement;
- (NSMutableDictionary *) entries;
- (NSMutableDictionary *) entriesByEntryName;
- (NSString *)getCurrentDate;
- (void) toggleDefaultSystemOfMeasurement;

@end


@interface AddEntryAlertViewController : UIViewController <UITextFieldDelegate> 

@property (nonatomic, assign) id <EntryListViewControllerDelegate> entryListViewControllerDelegate;
@property RPFloatingPlaceholderTextField *entryField;
@property RPFloatingPlaceholderTextField *dateLabel;
@property NSString *dateString;
@property BButton *confirmButton;

- (Entry *) makeEntryFromFields;
- (void) doConfirmEntryButton:(id)sender;

@end
