//
//  AddEntryAlertViewController.m
//  Swole
//
//  Created by gamaux01 on 2015/6/22.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "AddEntryAlertViewController.h"

@interface AddEntryAlertViewController () {
    CGFloat buttonAndLabelWidth;
    CGRect screenFrame;
    CGRect alertViewFrame;
    CGRect entryFieldFrame;
    CGRect dateLabelFrame;
    CGRect dismissButtonFrame;
    CGRect confirmButtonFrame;
    CGRect lineFrame;
    
}

@end

@implementation AddEntryAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFramesAndSizes];
    [self loadAlertView];
    [self loadEntryTextfield];
    [self loadDateLabel];
    [self loadLine];
    [self loadConfirmButton];
    [self loadDismissButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loading
- (void) loadFramesAndSizes {
    screenFrame = [[UIScreen mainScreen] bounds];
    buttonAndLabelWidth = screenFrame.size.width *.4f;
    alertViewFrame = CGRectMake(0, 0, screenFrame.size.width * .9f, screenFrame.size.height *.23f) ;
    entryFieldFrame = CGRectMake((alertViewFrame.size.width - buttonAndLabelWidth *2)*.33f, alertViewFrame.size.height* .22f, buttonAndLabelWidth, 35);
    dateLabelFrame = CGRectMake(buttonAndLabelWidth + 2*(alertViewFrame.size.width - buttonAndLabelWidth *2)*.33f, alertViewFrame.size.height * .22f, buttonAndLabelWidth, 35);
    lineFrame = CGRectMake(alertViewFrame.size.width *.5f, alertViewFrame.size.height * .08f, 1, alertViewFrame.size.height *.42f);
    dismissButtonFrame = CGRectMake((alertViewFrame.size.width - buttonAndLabelWidth *2)*.33f, alertViewFrame.size.height *.55f, buttonAndLabelWidth, 50);
    confirmButtonFrame = CGRectMake(buttonAndLabelWidth + (alertViewFrame.size.width - buttonAndLabelWidth *2)*.66f, alertViewFrame.size.height *.55f, buttonAndLabelWidth, 50);
}

- (void) loadAlertView {
    //rounded corners
    self.view.layer.cornerRadius = 7;
    self.view.layer.masksToBounds = YES;
    self.view.frame = alertViewFrame;
}

- (void) loadEntryTextfield {
    //entry textfield
    self.entryField = [[RPFloatingPlaceholderTextField alloc] initWithFrame:entryFieldFrame];
    self.entryField.placeholder = @"Routine";
    self.entryField.textAlignment = NSTextAlignmentCenter;
    self.entryField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.f];
    self.entryField.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview: self.entryField];
    [self.entryField becomeFirstResponder];
    self.entryField.text = @"";
    self.entryField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.entryField.delegate = self;
}

- (void) loadDateLabel {
    //date textfield
    self.dateLabel = [[RPFloatingPlaceholderTextField alloc] initWithFrame:dateLabelFrame];
    self.dateLabel.placeholder = @"Date";
    self.dateLabel.text = _dateString;
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.f];
    self.dateLabel.enabled = NO;
    [self.view addSubview:self.dateLabel];
}

- (void) loadLine {
    //line
    UIView *line = [[UIView alloc] initWithFrame:lineFrame];
    [line setBackgroundColor: [UIColor lightGrayColor]];
    [line setAlpha:.4f];
    [self.view addSubview:line];
}

- (void) loadDismissButton {
    //dismiss button
    BButton *dismissButton = [UIElementHelper createRectangularButtonWithText:@"Dismiss" FontSize:25.f Color: [UIColor ht_grapeFruitColor] AtLocation:dismissButtonFrame];
    [dismissButton addTarget:self action:@selector(doDismissButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
}

- (void) loadConfirmButton {
    //confirm button
    self.confirmButton = [UIElementHelper createRectangularButtonWithText:@"Confirm" FontSize:25.f Color: [UIColor ht_grapeFruitColor] AtLocation:confirmButtonFrame];
    [self.confirmButton addTarget:self action:@selector(doConfirmEntryButton:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.enabled = NO;
    [self.view addSubview:_confirmButton];
}

#pragma mark - Actions

    //create entry using textfields from the alert view
- (Entry *) makeEntryFromFields {
    return [[Entry alloc] initWithEntryName:self.entryField.text date:self.dateLabel.text units:[self.entryListViewControllerDelegate systemOfMeasurement]];
}

    //confirm button action
- (void)doConfirmEntryButton:(id)sender {
    [self.entryField resignFirstResponder]; //dismisses the entry field
    [self.entryListViewControllerDelegate addEntryToEntryList: [self makeEntryFromFields]];
}

- (void)doDismissButton {
    [self.entryField resignFirstResponder];
    [self.entryListViewControllerDelegate dismissExerciseAlertView];
}

#pragma mark - UITextFieldDelegate
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text length] == 0 && [string length] == 1) {
        self.confirmButton.enabled = YES;
    } else if ([textField.text length] == 1 && [string length] == 0){
        self.confirmButton.enabled = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!([textField.text length] == 0)) {
        [self.confirmButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return YES;
}

@end