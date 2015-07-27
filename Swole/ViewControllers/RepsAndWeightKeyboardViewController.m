//
//  RepsAndWeightKeyboardViewController.m
//  Swole
//
//  Created by gamaux01 on 2015/7/21.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "RepsAndWeightKeyboardViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "UIColor+HTColor.h"

@interface RepsAndWeightKeyboardViewController () {
    CGRect screenFrame;
    CGRect repsFieldFrame;
    CGRect xLabelFrame;
    CGRect weightFieldFrame;
    CGRect unitLabelFrame;
    CGRect checkedButtonFrame;
}

@end

@implementation RepsAndWeightKeyboardViewController

#pragma mark - RepsAndWeightKeyboardViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor ht_cloudsColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Information *) returnInfoFromFields {
    Information *info = [[Information alloc] initSetWithWeight:[self.weightField.text floatValue] reps:[self.repsField.text integerValue]];
    return info;
}

#pragma mark - Loading

- (void) loadAllViews {
    [self loadFrames];
    [self loadRepsField];
    [self loadxLabel];
    [self loadWeightField];
    [self loadUnitLabel];
    [self loadCheckedButton];
}

- (void) loadFrames {
    screenFrame = [[UIScreen mainScreen] bounds];
    CGFloat yStart = self.view.bounds.size.height - 130;
    
    CGFloat repsFrameWidth = screenFrame.size.width * .2f;
    CGFloat repsFrameHeight = 35;
    CGFloat leftPadding = screenFrame.size.width * .05f;

    repsFieldFrame = CGRectMake(leftPadding, yStart + 14, repsFrameWidth, repsFrameHeight);
    
    CGFloat xFrameWidth = 12;
    CGFloat xFrameHeight = 15;
    
    xLabelFrame = CGRectMake(repsFieldFrame.origin.x + repsFrameWidth + 13, yStart + 25, xFrameWidth, xFrameHeight);
    
    CGFloat weightFrameWidth = screenFrame.size.width * .28f;
    CGFloat weightFrameHeight = 35;
    
    weightFieldFrame = CGRectMake(xLabelFrame.origin.x + xFrameWidth + 13, yStart + 14, weightFrameWidth, weightFrameHeight);
    
    CGFloat unitFrameWidth = 30;
    CGFloat unitFrameHeight = 28;
    
    unitLabelFrame = CGRectMake(weightFieldFrame.origin.x + weightFrameWidth + 11, yStart + 19.f , unitFrameWidth, unitFrameHeight);

    CGFloat checkedButtonWidth = 40;
    CGFloat checkedButtonHeight = 40;
    CGFloat rightPadding = screenFrame.size.width * .05f;
    CGFloat spacing = screenFrame.size.width - checkedButtonWidth - rightPadding;
    
    checkedButtonFrame = CGRectMake(spacing, yStart + 13, checkedButtonWidth, checkedButtonHeight);
}

- (void) loadRepsField {
    self.repsField = [[UITextField alloc] initWithFrame:repsFieldFrame];
    self.repsField.placeholder = @"Reps";
    self.repsField.textAlignment = NSTextAlignmentCenter;
    self.repsField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.f];
    self.repsField.adjustsFontSizeToFitWidth = YES;
    self.repsField.text = @"";
    self.weightField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.repsField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.repsField.backgroundColor = [UIColor whiteColor];
    self.repsField.layer.cornerRadius = 7;
    self.repsField.layer.masksToBounds = YES;
    self.repsField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.repsField];
}

- (void) loadWeightField {
    self.weightField = [[UITextField alloc] initWithFrame:weightFieldFrame];
    self.weightField.placeholder = @"Weight";
    self.weightField.textAlignment = NSTextAlignmentCenter;
    self.weightField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.f];
    self.weightField.adjustsFontSizeToFitWidth = YES;
    self.weightField.text = @"";
    self.weightField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.weightField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.weightField.backgroundColor = [UIColor whiteColor];
    self.weightField.layer.cornerRadius = 7;
    self.weightField.layer.masksToBounds = YES;
    self.weightField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.weightField];
}

- (void) loadxLabel {
    self.xLabel = [[UILabel alloc] initWithFrame: xLabelFrame];
    self.xLabel.text = @"x";
    self.xLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:25.f];
    self.xLabel.textColor = [UIColor colorWithRed:.345f green:.345 blue:.345 alpha:1.f];
    [self.view addSubview:self.xLabel];
}

- (void) loadUnitLabel {
    self.unitLabel = [[UILabel alloc] initWithFrame: unitLabelFrame];
    self.unitLabel.text = @"kg";
    self.unitLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.f];
    self.unitLabel.textColor = [UIColor colorWithRed:.345f green:.345 blue:.345 alpha:1.f];
    [self.view addSubview:self.unitLabel];
}

- (void) loadCheckedButton {
    self.checkedButton = [[SpringButton alloc] initWithFrame:checkedButtonFrame];
//    [self.checkedButton setImage:[UIImage imageNamed:@"Checked-64.png"] forState:UIControlStateNormal];
    
    [self.checkedButton setTitle:@"\u2713" forState:UIControlStateNormal];
    self.checkedButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:45.f];
    [self.checkedButton setTitleColor:[UIColor colorWithRed:.345 green:.345 blue:.345 alpha:1] forState:UIControlStateNormal];
//    colorWithRed:.345 green:.345 blue:.345 alpha:1.0f
    [self.checkedButton addTarget:self action:@selector(doCheckedButton) forControlEvents:UIControlEventTouchUpInside];
    [self.checkedButton addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkedButton];
}

#pragma mark - Button Actions

- (void) doCheckedButton {//exercises must have a positive reps and weight value
    if ([self.repsField.text integerValue] > 0 && [self.weightField.text integerValue]) {
        [self.entryViewController2Delegate toEntryAddToExerciseAnInfo: [self returnInfoFromFields]];
        [self.repsField resignFirstResponder];
        [self.weightField resignFirstResponder];
    }
}

- (void) pop:(id)sender {//to emphasize that a button is clicked
    SpringButton *springButton = (SpringButton *)sender;
    springButton.animation = @"pop";
    springButton.curve = @"easeIn";
    springButton.force = 1.f;
    springButton.duration = .5f;
    [springButton animate];
}


@end
