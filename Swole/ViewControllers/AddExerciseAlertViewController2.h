//
//  AddExerciseAlertViewController2.h
//  Swole
//
//  Created by gamaux01 on 2015/7/20.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPFloatingPlaceholderTextField.h"
#import "Information.h"
#import "BButton.h"

/**
 *  Controls the dismissal of the alert view
 *  that contains AddExerciseAlertViewController2,
 *  also the addition of a new exercise to the entry that
 *  implements this delegate.
 */
@protocol EntryViewController2Delegate <NSObject>
- (void) dismissExerciseAlertView;
- (void) toEntryAddExerciseWithName:(NSString *)name;
- (void) toEntryAddToExerciseAnInfo:(Information *)info;
@end


@interface AddExerciseAlertViewController2 : UIViewController <UITextFieldDelegate> {
}

/**
 *  Delegates.
 */
@property id <EntryViewController2Delegate> entryViewController2Delegate;


/**
 *  Textfield.
 */
@property RPFloatingPlaceholderTextField *exerciseField;

/**
 *  Buttons.
 */
@property BButton *confirmButton;
@property BButton *dismissButton;

/**
 *  Loading - Methods that adjust the frame and visual properties of various views,
 *  then add the view to the main view.
 */
- (void) loadFramesAndSizes;
- (void) loadAlertView;
- (void) loadExerciseField;
- (void) loadDismissButton;
- (void) loadConfirmButton;
- (void) loadLine;

/**
 *  Button actions.
 */
- (void) doDismissButton;
- (void) doConfirmButton;


@end
