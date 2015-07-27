//
//  Swole
//  AddExerciseAlertViewController.h
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
#import "RPFloatingPlaceholderTextField.h"
#import "UIElementHelper.h"
#import "Entry.h"




@protocol AddExerciseDelegate <NSObject>
@required
- (void) dismiss;
- (void) addExerciseToEntryWithName:(NSString *) name info:(Information *)info;
@optional
@end

/**
 *  Controls the view that allows you to add exercises.
 */

@interface AddExerciseAlertViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate> {
    CGFloat _alertViewWidth;
    CGFloat _alertViewHeight;
}


@property (nonatomic, assign) id <AddExerciseDelegate> addExerciseDelegate;
@property NSMutableDictionary *entriesByEntryName;
@property NSMutableDictionary *entries;
@property NSString *entryName;
@property NSString *curDate;
@property NSArray *dates;
@property NSInteger numRows;
@property NSString *pickerExerciseName; //used to store the first exercise name of a past 'Entry', so the user does not have to select the first item from the picker manually

@property UIButton *toggleButton;

/**
 *  Textfields.
 */

@property RPFloatingPlaceholderTextField *exerciseName;
@property RPFloatingPlaceholderTextField *weight;
@property RPFloatingPlaceholderTextField *sets;
@property RPFloatingPlaceholderTextField *reps;

/**
 *  Picker view properties.
 */

@property BOOL pickerViewBool;
@property UIPickerView *pickerView;


/**
 *  Updates the number of rows for the picker exercise column
 *  based on the date selection in the left column.
 *
 *  @param dateIndex the date string's corresponding index in the date string array
 */

- (void) updateNumberOfRowsGivenDateIndex:(NSInteger) dateIndex;

- (Information *)makeInfoFromFields;
- (void)doDismissButton:(id)sender;
- (void)doConfirmExerciseButton:(id)sender;
- (void)toggleBetweenKeyboardAndPicker:(id)sender;
- (void)setExerciseNameText:(NSString *)exerciseName;


@end
