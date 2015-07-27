//
//  AddExerciseAlertViewController2.m
//  Swole
//
//  Created by gamaux01 on 2015/7/20.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "AddExerciseAlertViewController2.h"
#import "UIElementHelper.h"

@interface AddExerciseAlertViewController2 () {
    CGRect screenFrame;
    CGRect exerciseFieldFrame;
    CGRect dismissButtonFrame;
    CGRect confirmButtonFrame;
    CGRect alertViewFrame;
    CGRect lineFrame;
}

@end

@implementation AddExerciseAlertViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFramesAndSizes];
    [self loadAlertView];
    [self loadLine];
    [self loadConfirmButton]; //load confirm button before you load the exercisefield, due to delegate's method
    [self loadDismissButton];
    [self loadExerciseField];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loading
- (void) loadFramesAndSizes {
    screenFrame = [[UIScreen mainScreen] bounds];
    
    CGFloat buttonHeight = screenFrame.size.height * .07f;
    CGFloat buttonWidth = screenFrame.size.width * .4f;
    
    alertViewFrame = CGRectMake(0, 0, screenFrame.size.width * .9f, screenFrame.size.height * .23f);

    dismissButtonFrame = CGRectMake((alertViewFrame.size.width - buttonWidth * 2) * .33f, alertViewFrame.origin.y + alertViewFrame.size.height *.64f, buttonWidth, buttonHeight);
    confirmButtonFrame = CGRectMake((alertViewFrame.size.width - buttonWidth * 2) * .66f + buttonWidth, alertViewFrame.origin.y  +alertViewFrame.size.height *.64f, buttonWidth, buttonHeight);
    exerciseFieldFrame = CGRectMake(alertViewFrame.size.width * .5f - buttonWidth,alertViewFrame.origin.y + alertViewFrame.size.height * .22f, buttonWidth * 2, buttonHeight);
    lineFrame = CGRectMake(dismissButtonFrame.origin.x, exerciseFieldFrame.origin.y + exerciseFieldFrame.size.height, alertViewFrame.size.width - dismissButtonFrame.origin.x
                            * 2.f, 1.5f);
}

- (void) loadAlertView {
    //rounded corners
    self.view.layer.cornerRadius = 7;
    self.view.layer.masksToBounds = YES;
    self.view.frame = alertViewFrame;
}

- (void) loadExerciseField {
    self.exerciseField = [[RPFloatingPlaceholderTextField alloc] initWithFrame:exerciseFieldFrame];
    self.exerciseField.placeholder = @"Exercise";
    self.exerciseField.textAlignment = NSTextAlignmentCenter;
    self.exerciseField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:25.f];
    self.exerciseField.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview: self.exerciseField];
    [self.exerciseField becomeFirstResponder]; //brings out the keyboard
    self.exerciseField.text = @"";
    self.exerciseField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.exerciseField.delegate = self;
}

- (void) loadDismissButton {
    //dismiss button
    self.dismissButton = [UIElementHelper createRectangularButtonWithText:@"Dismiss" FontSize:25.f Color: [UIColor ht_grapeFruitColor] AtLocation:dismissButtonFrame];
    [self.dismissButton addTarget:self action:@selector(doDismissButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.dismissButton];
}

- (void) loadConfirmButton {
    //confirm button
    self.confirmButton = [UIElementHelper createRectangularButtonWithText:@"Confirm" FontSize:24.f Color: [UIColor ht_grapeFruitColor] AtLocation:confirmButtonFrame];
    [self.confirmButton addTarget:self action:@selector(doConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.enabled = NO;
    [self.view addSubview: self.confirmButton];
}

- (void) loadLine {
    UIView *line = [[UIView alloc] initWithFrame:lineFrame];
    line.backgroundColor = [UIColor ht_asbestosColor];
    [self.view addSubview:line];
}
#pragma mark - Button Actions

- (void) doDismissButton {
    [self.exerciseField resignFirstResponder];
    [self.entryViewController2Delegate dismissExerciseAlertView];
}

- (void) doConfirmButton {
    [self.exerciseField resignFirstResponder];
    [self.entryViewController2Delegate toEntryAddExerciseWithName:self.exerciseField.text];
}

#pragma mark - UITextFieldDelegate

//disables confirm button when textfield is empty
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text length] == 0 && [string length] == 1) {
        self.confirmButton.enabled = YES;
    } else if ([textField.text length] == 1 && [string length] == 0){
        self.confirmButton.enabled = NO;
    }
    return YES;
}

//pressing enter on the keyboard is equivalent to clicking confirm
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!([textField.text length] == 0)) {
        [self.confirmButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return YES;
}

@end