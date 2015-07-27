//
//  AddExerciseAlertViewController.m
//  Swole
//
//  Created by gamaux01 on 2015/6/18.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "AddExerciseAlertViewController.h"

@interface AddExerciseAlertViewController ()

@end

@implementation AddExerciseAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //convenience
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    _alertViewWidth = screenFrame.size.width - 12.5f;
    _alertViewHeight = screenFrame.size.height/3.1f;
    
    //rounded corners
    self.view.layer.cornerRadius = 7;
    self.view.layer.masksToBounds = YES;
    
    //size the view
    [self.view setFrame:CGRectMake(0, 0, _alertViewWidth, _alertViewHeight)];

    //set up
    [self loadButtons];
    [self loadSeparators];
    [self loadTextfields];
    [self setUpPickerView];
    
    //keyboard setup
    [_weight setKeyboardType:UIKeyboardTypeNumberPad];
    [_reps setKeyboardType:UIKeyboardTypeNumberPad];
    [_sets setKeyboardType:UIKeyboardTypeNumberPad];

    //past exercises setup
    _dates = _entriesByEntryName[_entryName];
    [self updateNumberOfRowsGivenDateIndex:0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - View Set up

-(void) loadTextfields {
    //exercise textfield
    _exerciseName = [[RPFloatingPlaceholderTextField alloc] initWithFrame:CGRectMake(_alertViewWidth/2.f - 70, _alertViewHeight * .09f, 140, 40)];
    _exerciseName.placeholder = @"Exercise";
    _exerciseName.textAlignment = NSTextAlignmentCenter;
    _exerciseName.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.f];
    _exerciseName.autocorrectionType = UITextAutocorrectionTypeNo;
    [_exerciseName setDelegate:self];
    
    //weight textfield
    _weight = [[RPFloatingPlaceholderTextField alloc] initWithFrame:CGRectMake(0, _alertViewHeight*.39f, _alertViewWidth/3.f, 40)];
    _weight.placeholder = @"Weight";
    _weight.textAlignment = NSTextAlignmentCenter;
    _weight.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.f];
    
    //sets (textfield)
    _sets = [[RPFloatingPlaceholderTextField alloc] initWithFrame:CGRectMake(_alertViewWidth/3.f, _alertViewHeight*.39f, _alertViewWidth/3.f, 40)];
    _sets.placeholder = @"Sets";
    _sets.textAlignment = NSTextAlignmentCenter;
    _sets.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.f];
    
    //reps textfield
    _reps = [[RPFloatingPlaceholderTextField alloc] initWithFrame:CGRectMake(2.f*_alertViewWidth/3.f, _alertViewHeight*.39f, _alertViewWidth/3.f, 40)];
    _reps.placeholder = @"Reps";
    _reps.textAlignment = NSTextAlignmentCenter;
    _reps.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.f];
    
    [self.view addSubview:_exerciseName];
    [self.view addSubview:_weight];
    [self.view addSubview:_sets];
    [self.view addSubview:_reps];
}

- (void) loadSeparators {
    //line - vertical 1
    UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(_alertViewWidth/3.f, _alertViewHeight*.09f + 40.f, 1, _alertViewHeight*.39f - _alertViewHeight*.09f)];
    [lineV1 setBackgroundColor: [UIColor lightGrayColor]];
    [lineV1 setAlpha:.4f];
    
    //line - vertical 2
    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(2*_alertViewWidth/3.f, _alertViewHeight*.09f + 40.f, 1, _alertViewHeight*.39f - _alertViewHeight*.09f)];
    [lineV2 setBackgroundColor: [UIColor lightGrayColor]];
    [lineV2 setAlpha:.4f];
    
    //line - horizontal 1
    UIView *lineH1 = [[UIView alloc] initWithFrame:CGRectMake(10, _alertViewHeight*.09f + 40.f, _alertViewWidth - 20, 1)];
    [lineH1 setBackgroundColor: [UIColor lightGrayColor]];
    [lineH1 setAlpha:.4f];
    
    //line - horizontal 2
    UIView *lineH2 = [[UIView alloc] initWithFrame:CGRectMake(10, _alertViewHeight*.39f + 40.f, _alertViewWidth - 20, 1)];
    [lineH2 setBackgroundColor: [UIColor lightGrayColor]];
    [lineH2 setAlpha:.4f];
    
    [self.view addSubview:lineV1];
    [self.view addSubview:lineV2];
    [self.view addSubview:lineH1];
    [self.view addSubview:lineH2];
}

- (void) loadButtons {
    //dismiss button
    BButton *dismissButton = [UIElementHelper createRectangularButtonWithText:@"Dismiss" FontSize:22.f Color:[UIColor ht_emeraldColor] AtLocation:CGRectMake((_alertViewWidth - 260)/3, _alertViewHeight * .68f, 130, 50)];
    [dismissButton addTarget:self action:@selector(doDismissButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //confirm button
    BButton *confirmButton = [UIElementHelper createRectangularButtonWithText:@"Confirm" FontSize:22.f Color:[UIColor ht_alizarinColor] AtLocation:CGRectMake(130 + 2*(_alertViewWidth - 260)/3, _alertViewHeight * .68f, 130, 50)];
    [confirmButton addTarget:self action:@selector(doConfirmExerciseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmButton];
    [self.view addSubview:dismissButton];
}

- (void) setUpPickerView {
    //toggle button for picker view
    _toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(_alertViewWidth/2.f + 70, _alertViewHeight * .11f, 32, 32)];
    [_toggleButton addTarget:self action:@selector(toggleBetweenKeyboardAndPicker:)
            forControlEvents:UIControlEventTouchUpInside];
    UIImage *pickerImg = [UIImage imageNamed:@"Past-32.png"];
    [_toggleButton setImage:pickerImg forState:UIControlStateNormal];
    _toggleButton.hidden = YES;
    
    [[UIPickerView appearance] setBackgroundColor:[UIColor whiteColor]];
    _pickerViewBool = NO;
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [_pickerView setDelegate:self];
    [self.view addSubview:_toggleButton];
}

#pragma mark - Actions

- (void) updateNumberOfRowsGivenDateIndex:(NSInteger) dateIndex {
    _curDate = _dates[dateIndex];
    Entry *entry = _entries[_curDate];
    NSMutableArray *exerciseNames = [entry exerciseNames];
    _numRows = [exerciseNames count];
}

- (void)setExerciseNameText:(NSString *)exerciseName {
    _exerciseName.text = exerciseName;
}

- (void)doDismissButton:(id)sender {
    [self resignFirstResponder];
    [_addExerciseDelegate dismiss];
}

//confirm button action
- (void)doConfirmExerciseButton:(id)sender{
        [self resignFirstResponder];
        NSString *name = [_exerciseName text];
        Information *info = [self makeInfoFromFields];
        [_addExerciseDelegate addExerciseToEntryWithName:name info:info];
}

- (Information *)makeInfoFromFields{
    NSString *weightStr = [self.weight text];
    NSString *repsStr = [self.reps text];
//    NSString *setsStr = [_sets text];
    float weight =  [weightStr floatValue];
    NSInteger reps = [repsStr intValue] == 0 ? 1 : [repsStr intValue];
//    NSInteger sets = [setsStr intValue] == 0 ? 1 : [setsStr intValue];

    
    return [[Information alloc] initSetWithWeight:weight reps:reps];
}

- (void)toggleBetweenKeyboardAndPicker:(id)sender {
    UIImage *img;
    _pickerViewBool = !_pickerViewBool;
    if (_pickerViewBool) {
        img = [UIImage imageNamed:@"PastFilled-32.png"];
        [_toggleButton setImage:img forState:UIControlStateNormal];
        [_exerciseName setInputView:_pickerView];
        [_exerciseName reloadInputViews];
        [_pickerView setAlpha:0.0f];
        [UIView animateWithDuration:.17f delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             [_pickerView setAlpha:1.0f];
                         }
                         completion:^(BOOL completed){
                             _exerciseName.text = _pickerExerciseName; //sets it to the first item
                         }
         ];
              } else {
                  img = [UIImage imageNamed:@"Past-32.png"];
                  [_toggleButton setImage:img forState:UIControlStateNormal];
                  [UIView animateWithDuration:.12f delay:0.0 options:UIViewAnimationOptionTransitionNone
                                   animations:^{
                                       [_pickerView setAlpha:0.0f];
                                   }
                                   completion:^(BOOL completed){
                                       [_exerciseName setInputView:nil];
                                       [_exerciseName reloadInputViews];
                                   }];
    }
}

#pragma mark -UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_dates count];
    } else {
        return _numRows;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return _dates[row];
    } else {
        Entry *entry= _entries[_curDate];
        NSMutableArray *exerciseNames = [entry exerciseNames];
        _pickerExerciseName = [exerciseNames count] != 0 ? exerciseNames[row] : @"";
        return _pickerExerciseName;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (component == 0) {//when selecting a new date
        [self updateNumberOfRowsGivenDateIndex:row]; // updates the current date
        [pickerView reloadComponent:1]; // reloads the exercise picker component
        Entry *entry= _entries[_curDate]; //uses the updated current date
        NSMutableArray *exerciseNames = [entry exerciseNames]; // gets the array of exercise names
        _pickerExerciseName = [exerciseNames count] != 0 ? exerciseNames[0] : @"";//every time you change the date component, select the first item of the exercise component as you current exercise
        _exerciseName.text = _pickerExerciseName; //sets the exercise name to the item
    } else if (component == 1) {
        if (_numRows != 0){
            Entry *entry= _entries[_curDate];
            NSMutableArray *exerciseNames = [entry exerciseNames];
            _exerciseName.text = exerciseNames[row]; //set the exercise to the row selected
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _toggleButton.hidden = NO;
    _toggleButton.alpha = 0.f;
    [UIView animateWithDuration:.3f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _toggleButton.alpha = 1.f;
    } completion:nil];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:.3f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _toggleButton.alpha = 0.f;
    } completion:nil];
    return YES;
}

@end