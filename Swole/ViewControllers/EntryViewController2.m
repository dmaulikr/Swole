//
//  EntryViewController2.m
//  Swole
//
//  Created by gamaux01 on 2015/7/20.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "EntryViewController2.h"
#import "EntryCellData.h"
#import "UIColor+HTColor.h"
#import "Swole-Swift.h"

@interface EntryViewController2 () {
    CGRect screenFrame;
    CGRect navigationBarButtonFrame;
    CGRect repsAndWeightKeyboardViewFrameIn;
    CGRect repsAndWeightKeyboardViewFrameOut;
    BOOL firstClick;
    NSDictionary *descriptionCellTextLabelFontAttributes;
    NSDictionary *descriptionCellDetailTextLabelFontAttributes;
    NSDictionary *exerciseCellTextLabelFontAttributes;
    NSDictionary *infoCellTextLabelFontAttributes;
}

@end

#pragma mark - EntryViewController2 Methods

@implementation EntryViewController2

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithEntry:(Entry *)entry {
    self = [[EntryViewController2 alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.entry = entry;
        self.exerciseNames = [entry exerciseNames];
        self.exercises = [entry exercises];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    firstClick = YES;
    [self loadFrames];
    [self loadFontAttributes];
    [self loadCreateExerciseBarButton];
    [self loadData];
    [self loadFooterView];
    [self loadRepsAndWeightKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//bumps repsAndSetKeyboard up
- (void)keyboardFrameDidChange:(NSNotification *)notification
{
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.repsAndWeightKeyboardViewController.view.frame;
    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
    CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
    
    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
    self.repsAndWeightKeyboardViewController.view.frame = newFrame;
    
    [UIView commitAnimations];
    
    [self resizeEntryTableView];
    [self.entryTableView scrollToRowAtIndexPath:self.currentExerciseCellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void) removeRepsAndWeightKeyboardViewControllerFromContainer {
    [self.repsAndWeightKeyboardViewController.repsField resignFirstResponder];
    [self.repsAndWeightKeyboardViewController.weightField resignFirstResponder];
    [self.repsAndWeightKeyboardViewController willMoveToParentViewController:nil];
    [self.repsAndWeightKeyboardViewController.view removeFromSuperview];
    [self.repsAndWeightKeyboardViewController removeFromParentViewController];
}

#pragma mark - Loading

- (void) loadRepsAndWeightKeyboard {
    self.repsAndWeightKeyboardViewController = [[RepsAndWeightKeyboardViewController alloc] initWithNibName:@"RepsAndWeightKeyboardViewController" bundle:nil];
    self.repsAndWeightKeyboardViewController.entryViewController2Delegate = self;
    [self addChildViewController:self.repsAndWeightKeyboardViewController];
    self.repsAndWeightKeyboardViewController.view.frame = repsAndWeightKeyboardViewFrameOut;
    [self.repsAndWeightKeyboardViewController loadAllViews];
    [self.view addSubview: self.repsAndWeightKeyboardViewController.view];
    [self.repsAndWeightKeyboardViewController didMoveToParentViewController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void) loadFrames {
    screenFrame = [[UIScreen mainScreen] bounds];
    navigationBarButtonFrame = CGRectMake(0, 0, 32, 32);
    repsAndWeightKeyboardViewFrameIn = CGRectMake(0, screenFrame.size.height - 130, screenFrame.size.width, 130);
    repsAndWeightKeyboardViewFrameOut = CGRectMake(0, screenFrame.size.height, screenFrame.size.width, 130);
}

- (void) loadData {
    if (self.entry) {
        self.data = [EntryCellData convertEntryToEntryCellDataArray: self.entry];
        self.dataWithoutHiddenExercises = self.data;
    } else {
        [NSException raise:@"Invalid Entry Exception" format:@"No entry object exists for conversion!"];
    }
}

- (void) loadFontAttributes {
    descriptionCellTextLabelFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"AvenirNext-Regular" size:35.f], NSFontAttributeName, nil];

    descriptionCellDetailTextLabelFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"AvenirNext-Regular" size:25.f], NSFontAttributeName, nil];

    exerciseCellTextLabelFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"AvenirNext-Regular" size:20.f], NSFontAttributeName, nil];
    
    infoCellTextLabelFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"AvenirNext-Regular" size:15.f], NSFontAttributeName, nil];
}

- (void)loadFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame: CGRectZero];
    self.entryTableView.tableFooterView = footerView;
}

- (void) loadCreateExerciseBarButton {
    SpringButton *createExerciseButton = [[SpringButton alloc] initWithFrame: navigationBarButtonFrame];
    UIImage *image = [UIImage imageNamed:@"Create New-50.png"];
    [createExerciseButton setImage:image forState:UIControlStateNormal];
    [createExerciseButton addTarget:self action:@selector(doCreateExerciseAlertView) forControlEvents: UIControlEventTouchUpInside];
    self.createExerciseBarButton = [[UIBarButtonItem alloc] initWithCustomView: createExerciseButton];
    [self.navigationItem setRightBarButtonItem: self.createExerciseBarButton animated:YES];
}

#pragma mark - Resizing
- (void) resizeEntryTableView {
    self.entryTableView.frame = CGRectMake(0, 0, screenFrame.size.width, self.repsAndWeightKeyboardViewController.view.frame.origin.y);
}
#pragma mark - Animations

- (void) slideRepsAndWeightKeyboardIn {
    [UIView animateWithDuration:.5f delay:.0f usingSpringWithDamping:.6f initialSpringVelocity:4.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.repsAndWeightKeyboardViewController.view.frame = repsAndWeightKeyboardViewFrameIn;
    }completion:nil ];
    [self resizeEntryTableView];
}

- (void) slideRepsAndWeightKeyboardOut {
    [self.repsAndWeightKeyboardViewController.repsField resignFirstResponder];
    [self.repsAndWeightKeyboardViewController.weightField resignFirstResponder];
    [UIView animateWithDuration:.3f delay:.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.repsAndWeightKeyboardViewController.view.frame = repsAndWeightKeyboardViewFrameOut;
    }completion:nil ];
    [self resizeEntryTableView];
}

- (void) animateReloadForTable:(UITableView *)table {
    [UIView transitionWithView:table
                      duration:0.35f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void)
     {
         [table reloadData];
     }
                    completion:nil];
}

#pragma mark - Helper

- (void) toggleCollapseOrExpandExercise: (EntryCellData *)exercise {
    NSArray *resultArray = [EntryCellData modifyInfoOfExercise:exercise InDataArray:self.data Hide: ![exercise.attributes[@"Hidden"] boolValue]]; //toggle
    self.data = resultArray[0];
    self.dataWithoutHiddenExercises = resultArray[1];
    [self animateReloadForTable:self.entryTableView];
}


#pragma mark - Button Actions

- (void) doCreateExerciseAlertView {
    self.exerciseAlertView = [[CustomIOSAlertView alloc] init];
    self.addExerciseAlertViewController2 =  [[AddExerciseAlertViewController2 alloc] initWithNibName:@"AddExerciseAlertViewController2" bundle:nil];
    
    self.addExerciseAlertViewController2.entryViewController2Delegate = self;
    self.exerciseAlertView.containerView = self.addExerciseAlertViewController2.view;
    self.exerciseAlertView.buttonTitles = nil;
    self.exerciseAlertView.useMotionEffects = YES;
    [self.exerciseAlertView show];
    [self slideRepsAndWeightKeyboardOut];
}

#pragma mark - EntryViewController2Delegate

- (void) dismissExerciseAlertView {
    [self.exerciseAlertView close];
}

- (void) toEntryAddExerciseWithName:(NSString *)name {
    [self.entry addExerciseWithName:name];
    [self.entryListViewControllerDelegate saveToUserDefaults];
    [self loadData];
    [self animateReloadForTable:self.entryTableView];
    [self.exerciseAlertView close];
}

- (void) toEntryAddToExerciseAnInfo:(Information *)info {
    [self.entry addExerciseWithName:self.currentExercise Info:info];
    [self.entryListViewControllerDelegate saveToUserDefaults];
    [self loadData];
    [self animateReloadForTable:self.entryTableView];
    [self.entryTableView scrollToRowAtIndexPath:self.currentExerciseCellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EntryCellData *entryCellData = self.data[indexPath.row];
    if (entryCellData.type == DESCRIPTION) {
        return 120;
    } else if (entryCellData.type == EXERCISE){
        return 40;
    } else {
        return 25;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EntryCellData *entryCellData = self.dataWithoutHiddenExercises[indexPath.row];
    if (entryCellData.type == EXERCISE) {
        if ([entryCellData.attributes[@"Hidden"] boolValue] == NO) {//case 1: clicking on an expanded cell
            if ([self.lastSelectedCellIndexPath isEqual:indexPath]) {//case 1a: clicking on same cell before
                [self.entryTableView deselectRowAtIndexPath:indexPath animated:YES];
                [self toggleCollapseOrExpandExercise:entryCellData];//collapse the cell
                self.lastSelectedCellIndexPath = nil;//slide the keyboard out
                [self slideRepsAndWeightKeyboardOut];
            } else {//case 1b: clicking on a new cell
                self.lastSelectedCellIndexPath = indexPath;
                [self slideRepsAndWeightKeyboardIn];
            }
        } else {//case 2: clicking on a collapsed cell
            [self toggleCollapseOrExpandExercise:entryCellData];
            [self.entryTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            self.lastSelectedCellIndexPath = indexPath;
            [self slideRepsAndWeightKeyboardIn];
        }
    }
    
    [self.entryTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.currentExercise = entryCellData.attributes[@"Exercise Name"]; //save the name of the current exercise to add information to
    self.currentExerciseCellIndexPath = indexPath; //for scrolling
    [self.repsAndWeightKeyboardViewController.repsField resignFirstResponder];
    [self.repsAndWeightKeyboardViewController.weightField resignFirstResponder];
    
}

// You may only select EXERCISE cells

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    EntryCellData *entryCellData = (EntryCellData *) self.dataWithoutHiddenExercises[indexPath.row];
    return entryCellData.type == EXERCISE;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataWithoutHiddenExercises count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //set up cells with object pooling
    static NSString *cellIdentifier = @"Cell"; //different queues for different type of cells
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];//gets a cell from the queue
    
    if (cell == nil) { //creates a new one if the dequeue doesn't have any cells
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    
    EntryCellData *entryCellData = self.dataWithoutHiddenExercises[indexPath.row]; //self.numberHidden is initially 0
    NSDictionary *cellAttributes = entryCellData.attributes;
    
    //filling the text in textfields
    if (entryCellData.type == DESCRIPTION) {
        NSAttributedString *entryNameAttributedString = [[NSAttributedString alloc] initWithString:cellAttributes[@"Entry Name"] attributes:descriptionCellTextLabelFontAttributes];
        cell.textLabel.attributedText = entryNameAttributedString;
        
        NSAttributedString *dateStringAttributedString = [[NSAttributedString alloc] initWithString:cellAttributes[@"Date String"] attributes:descriptionCellDetailTextLabelFontAttributes];
        cell.detailTextLabel.attributedText = dateStringAttributedString;
        
    } else if (entryCellData.type == EXERCISE) {
        NSAttributedString *exerciseNameAttributedString = [[NSAttributedString alloc] initWithString: cellAttributes[@"Exercise Name"] attributes:exerciseCellTextLabelFontAttributes];
        cell.textLabel.attributedText = exerciseNameAttributedString;
        cell.detailTextLabel.text = @""; //reusing cells
        
    } else if (entryCellData.type == INFORMATION) {
        NSString *infoString = [NSString stringWithFormat:@"\t %d. %d x %d %@", [cellAttributes[@"Set Number"] intValue], [cellAttributes[@"Reps"] intValue], [cellAttributes[@"Weight"] intValue], @"kg"];
        NSAttributedString *infoAttributedString = [[NSAttributedString alloc] initWithString: infoString attributes:infoCellTextLabelFontAttributes];
        cell.textLabel.attributedText = infoAttributedString;
        cell.detailTextLabel.text = @""; //reusing cells, make sure to clear out detailed text, which isn't used in INFORMATION
    }
    
    NSMutableDictionary *mutableAttributes = [entryCellData.attributes mutableCopy];
    [mutableAttributes setObject:indexPath forKey:@"Index Path"];
    entryCellData.attributes = [mutableAttributes copy];
    
    return cell;
}

//cannot edit DESCRIPTION
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !(indexPath.row == 0);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    EntryCellData *entryCellData = self.data[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //code runs when you hit delete
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (entryCellData.type == EXERCISE) {
            [self.entry deleteExerciseWithName:cell.textLabel.text];
        } else if (entryCellData.type == INFORMATION) {
            NSMutableArray *infoArray = self.exercises[entryCellData.attributes[@"Parent Exercise Name"]];
            int index = [entryCellData.attributes[@"Set Number"] intValue] - 1;
            [infoArray removeObjectAtIndex: index];
        }
        [self.entryListViewControllerDelegate saveToUserDefaults];
        [self loadData];
        [self animateReloadForTable:self.entryTableView];
    }
}


@end
