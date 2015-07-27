//
//  EntryViewController.m
//  Swole
//
//  Created by gamaux01 on 2015/6/18.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "Swole-Swift.h"
#import "EntryViewController.h"
#import "Colours.h"

@interface EntryViewController () {
    CGRect screenFrame;
    CGRect navigationBarButtonFrame;

}

@property UIBarButtonItem *createNewExerciseBarButton;

@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //convert data
    SystemOfMeasurement curSystem = [self.entryListViewControllerDelegate systemOfMeasurement];//at start up, makes a conversion if the last system of measurement differed
    if (!([_entry lastSystem] == curSystem)) {
        [_entry convertTo:curSystem];
    }
    
    
    [self loadSizes];
    [self loadNavigationBar];
    [self loadNavigationBarTitle];
    [self loadCreateNewExerciseButton];
    
    //tree view
    [self loadData];


    [self setUpTreeView];
    [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _treeView.frame = self.view.bounds;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.entry setLastSystem: [self.entryListViewControllerDelegate systemOfMeasurement]]; //save system of measurement before you exit the entry view
//    [_userDefaultDelegate saveToUserDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loading

- (void)loadSizes {
    screenFrame = [[UIScreen mainScreen] bounds];
    navigationBarButtonFrame = CGRectMake(0, 0, 32, 32);
}

- (void) loadNavigationBarTitle {
    //navigation bar title
    
    SpringButton *titleButton = [[SpringButton alloc] initWithFrame: CGRectMake(0, 0, 10, 0)];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString: @"Analyze"];
    NSDictionary *fontAttributes =   [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"AvenirNext-Regular" size:30.f],
                                      NSFontAttributeName, nil];
    [titleString setAttributes:fontAttributes range:NSMakeRange(0, [titleString length])];
    [titleButton setAttributedTitle: titleString forState: UIControlStateNormal];
    
    [titleButton addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchDown];
    [titleButton addTarget:self action:@selector(showAnalysisView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:titleButton];
}

- (void) loadCreateNewExerciseButton {
    SpringButton *createNewExerciseButton = [[SpringButton alloc] initWithFrame: navigationBarButtonFrame];

    UIImage *image = [UIImage imageNamed:@"Create New-50.png"];
    [createNewExerciseButton setImage:image forState:UIControlStateNormal];
    [createNewExerciseButton addTarget:self action:@selector(spin:) forControlEvents:UIControlEventTouchDown];
    
    [createNewExerciseButton addTarget:self action:@selector(showAddExerciseAlertView:) forControlEvents: UIControlEventTouchUpInside];
    
    self.createNewExerciseBarButton = [[UIBarButtonItem alloc] initWithCustomView: createNewExerciseButton];
    
    [self.navigationItem setRightBarButtonItem: self.createNewExerciseBarButton animated:YES];
}


- (void)loadNavigationBar {
    
    //title
    [self.navigationItem setTitle:[_entry dateStr]];
    
    //initialization
    _exerciseNames = [_entry exerciseNames];
    _exercises = [_entry exercises];
}

- (void)loadNewExerciseButton {
    //"new exercise" plus
    FRDLivelyButton *addExerciseButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,25,25)];
    [addExerciseButton setStyle:kFRDLivelyButtonStylePlus animated:NO];
    [addExerciseButton setStyle:kFRDLivelyButtonStyleCirclePlus animated:YES];
    [addExerciseButton setOptions:@{ kFRDLivelyButtonLineWidth: @(1.2f),
                                     kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                                     kFRDLivelyButtonColor: [UIColor blueColor]
                                     }];
    [addExerciseButton addTarget:self action:@selector(showAddExerciseAlertView:) forControlEvents:UIControlEventTouchUpInside];
    _addExerciseBarButton = [[UIBarButtonItem alloc] initWithCustomView:addExerciseButton];
}

#pragma mark - Animations

- (void) spin: (id) sender {
    SpringButton *springButton = (SpringButton *)sender;
    springButton.animation = @"swing";
    springButton.curve = @"easeIn";
    springButton.force = .5f;
    springButton.duration = .5f;
    [springButton animate];
}

- (void) clickTitle: (id) sender{
    SpringButton *titleView = (SpringButton *)sender;
    titleView.animation = @"pop";
    titleView.curve = @"easeIn";
    titleView.force = 1.8f;
    titleView.duration = .5f;
    [titleView animate];
}

#pragma mark - Actions

//- (void)toggleSystem {
//
//    //first adjust the measurement system
//    [_entryListDelegate toggleDefaultSystemOfMeasurement]; //toggle the measurement system at the 'EntryList' level
//    if ([_entry count] == 0) {
//        [self toggleSystemOfMeasurement]; //no need to update table if there aren't any 'Entry's
//    } else {
//        [self toggleSystemOfMeasurementAndUpdateTable];
//    }
//    [_entry setLastSystem: [_entryListDelegate systemOfMeasurement]]; //save system of measurement every time you toggle
//    
//    //set up new text and button color for the new system
//    SystemOfMeasurement sys = [_entryListDelegate systemOfMeasurement];
//    UIColor *buttonColor;
//    if (sys == METRIC) {
//        _unit = @"kg";
//        buttonColor = [UIColor ht_amethystColor];
//    } else if (sys == IMPERIAL) {
//        _unit = @"lb";
//        buttonColor = [UIColor ht_peterRiverColor];
//    }
//    
//    //get the custom view and update it with animation
//    BButton *systemOfMeasurementButton = (BButton *)_systemOfMeasurementBButton.customView;
//    
//    
//    [UIView animateWithDuration:.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        systemOfMeasurementButton.alpha = 0.f;
//    }completion:^(BOOL completed){
//        [systemOfMeasurementButton setTitle:_unit forState:UIControlStateNormal];
//        [systemOfMeasurementButton setColor: buttonColor];
//    }];
//    [UIView animateWithDuration:.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        systemOfMeasurementButton.alpha = 1.f;
//    } completion:nil];
//}
//
//- (void)toggleSystemOfMeasurement {
//    //converts values in 'Entry' to correspond to the current system of measurement
//    [_entry convertTo:[_entryListDelegate systemOfMeasurement]];
//    
//    //adjusts the blank page view to the correct system
//    NSString *systemTypeStr = ([_entryListDelegate systemOfMeasurement] == METRIC)? systemTypeStr = @"Metric System" : @"Imperial System";
//    UILabel *blankViewLabel = (UILabel *)[_noExercisesView viewWithTag:1];
//    [blankViewLabel setText:systemTypeStr];
//    [_noExercisesView setNeedsDisplay];
//    [_userDefaultDelegate saveToUserDefaults];
//}
//
//- (void)toggleSystemOfMeasurementAndUpdateTable {
//    [_entry convertTo:[_entryListDelegate systemOfMeasurement]];
//    //after converting the 'Entry', display the new data onto the TreeView
//    
//    //remove focus and arrow
//    [self removeFocusFromCurrentArrow:YES];
//    
//    //convert new data to RADataObjects and load
//    
//    [self loadData];
//    [_userDefaultDelegate saveToUserDefaults];
//    [UIView transitionWithView:_treeView
//                      duration:0.35f
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:^(void)
//     {
//         [_treeView reloadData];
//     }
//                    completion: nil];
//}

#pragma mark - AddExerciseDelegate

- (void)dismiss {
    [_exerciseAlertView close];
}

- (void)addExerciseToEntryWithName:(NSString *)name info:(Information *)info {
    [_entry addExerciseWithName:name Info:info];
    [self loadData];
    [_treeView reloadData];
//    [_userDefaultDelegate saveToUserDefaults]; //save after add
    [_exerciseAlertView close];
}

#pragma mark - Navigation

- (void)showAddExerciseAlertView:(SpringButton *)sender {
    
    _exerciseAlertView = [[CustomIOSAlertView alloc] init];
    _addExerciseAlertViewController =  [[AddExerciseAlertViewController alloc] initWithNibName:@"AddExerciseAlertViewController" bundle:nil];
    [_addExerciseAlertViewController setAddExerciseDelegate:self];
    [_addExerciseAlertViewController setEntriesByEntryName: [self.entryListViewControllerDelegate entriesByEntryName]];
    [_addExerciseAlertViewController setEntries: [self.entryListViewControllerDelegate entries]];
    [_addExerciseAlertViewController setEntryName:[_entry entryName]];
    [_exerciseAlertView setContainerView:_addExerciseAlertViewController.view];
    [_exerciseAlertView setButtonTitles: nil];
    [_exerciseAlertView setUseMotionEffects:TRUE];
    [_exerciseAlertView show];

}

- (void)showAnalysisView{

    AnalysisViewController *analysisViewController = [[AnalysisViewController alloc] initWithNibName:@"AnalysisViewController" bundle:nil];
        [analysisViewController setExerciseName:_exerciseName];
        [analysisViewController setEntryList: [self.entryListViewControllerDelegate getEntryList]];
        [self.navigationController pushViewController:analysisViewController animated:YES];
}

//////////TREE VIEW CODE/////////////

- (void)setUpTreeView {
    _treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
    _treeView.delegate = self;
    _treeView.dataSource = self;
    _treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    [self loadFooterView];
    [_treeView reloadData];
    [self.view insertSubview:_treeView atIndex:1];
}

- (void)loadFooterView {
    CGRect footerFrame = _treeView.treeFooterView.frame;
    UIView *grayFooter = [[UIView alloc] initWithFrame:footerFrame];
    grayFooter.backgroundColor = [UIColor ht_cloudsColor];
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, 1)];
    separatorLine.backgroundColor = [UIColor ht_silverColor];
    [grayFooter addSubview:separatorLine];
    _treeView.treeFooterView = grayFooter;
}

- (void)loadData
{
    
    NSMutableArray *mutableData = [DataElementHelper convertEntryToDataArray:_entry];
    self.data = mutableData;
    
}

#pragma mark TreeView Delegate methods

//do not collapse any items
- (BOOL)treeView:(RATreeView *)treeView shouldCollapaseRowForItem:(id)item {
    return NO;
}

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    RADataObject *dataItem = (RADataObject *)item;
    if (dataItem.RADataObjectType == DESCRIPTION){
        return 120;
    } else {
        return 40;
    }
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    RADataObject *dataItem = (RADataObject *)item;
    return dataItem.RADataObjectType != DESCRIPTION;
}

//- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
//{
//    //set up
//    UIButton *chartButton = (UIButton *)_analysisButton.customView;
//    UIImage *chartImage;
//    RADataObject *dataItem = (RADataObject *)item;
//    RATableViewCell *cell = (RATableViewCell *) [_treeView cellForItem:item];
//
//    if (dataItem.RADataObjectType == EXERCISE) {//cell will be EXERCISE type
//        if (!_cellWithFocus) {//if it's the first EXERCISE cell clicked
//            _cellWithFocus = cell; //give it focus
//            [_cellWithFocus toggleArrow]; //then show its arrow
//        } else if (_cellWithFocus != cell) {//if it's not the first EXERCISE cell clicked
//            [_cellWithFocus toggleArrow]; //first hide the old cell
//            _cellWithFocus = cell; //then do the same as above
//            [_cellWithFocus toggleArrow];
//        }
//        chartImage = [UIImage imageNamed:@"Bar Chart Filled-25.png"];//indicate you can run an analysis now that you've selected an EXERCISE cell
//        [chartButton setImage:chartImage forState:UIControlStateNormal];
//        _analysisButton.tag = 1; //let the filled chart have a tag of 1
//
//    } else {
//        [_cellWithFocus toggleArrow]; //toggle the arrow off the old cell
//        _cellWithFocus = cell; //set focus to new cell
//        chartImage = [UIImage imageNamed:@"Bar Chart-25.png"];
//        [chartButton setImage:chartImage forState:UIControlStateNormal];
//        _analysisButton.tag = 0;
//    }
//}
//
//- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
//{
//    //set up
//    UIButton *chartButton = (UIButton *)_analysisButton.customView;
//    UIImage *chartImage;
//    RADataObject *dataItem = (RADataObject *)item;
//    RATableViewCell *cell = (RATableViewCell *) [_treeView cellForItem:item];
//    
//    if (dataItem.RADataObjectType == EXERCISE) {//cell will be EXERCISE type
//        if (!_cellWithFocus) {//if it's the first EXERCISE cell clicked
//            _cellWithFocus = cell; //give it focus
//            [_cellWithFocus toggleArrow]; //then show its arrow
//        } else if (_cellWithFocus != cell) {//if it's not the first EXERCISE cell clicked
//            [_cellWithFocus toggleArrow]; //first hide the old cell
//            _cellWithFocus = cell; //then do the same as above
//            [_cellWithFocus toggleArrow];
//        }
//        chartImage = [UIImage imageNamed:@"Bar Chart Filled-25.png"];//indicate you can run an analysis now that you've selected an EXERCISE cell
//        [chartButton setImage:chartImage forState:UIControlStateNormal];
//        _analysisButton.tag = 1; //let the filled chart have a tag of 1
//        
//    } else {
//        [_cellWithFocus toggleArrow];
//        _cellWithFocus = cell;
//        chartImage = [UIImage imageNamed:@"Bar Chart-25.png"];
//        [chartButton setImage:chartImage forState:UIControlStateNormal];
//        _analysisButton.tag = 0;
//    }
//}

- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    //deletion
    NSUInteger index;
    RADataObject *itemParent = [self.treeView parentForItem:item];
    RADataObject *dataItem = (RADataObject *)item;
    
    if (itemParent == nil) {//if it's an exercise item, delete it from the _data array
        index = [_data indexOfObject:item];
        [_data  removeObject:item];
        [_entry deleteExerciseWithName:dataItem.name];
//        [_userDefaultDelegate saveToUserDefaults];
    } else { //otherwise, delete the respective information
        index = [itemParent.infoArray indexOfObject:item];
        [_entry deleteInformationAtIndex:index FromExercise:dataItem.name];
//        [_userDefaultDelegate saveToUserDefaults];
        [self loadData]; //todo: less expensive way to do this
    }
    [self.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:itemParent withAnimation:RATreeViewRowAnimationNone];
    if (itemParent) {
        [self.treeView reloadRowsForItems:@[itemParent] withRowAnimation:RATreeViewRowAnimationNone];
    }
    [treeView reloadData];
    [treeView setNeedsDisplay];
    [treeView.treeFooterView setNeedsDisplay];
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    RADataObject *dataItem = (RADataObject *)item;
    FRDLivelyButton *addExerciseButton = (FRDLivelyButton *)_addExerciseBarButton.customView;
    if (dataItem.RADataObjectType == EXERCISE) {
        [addExerciseButton setStyle:kFRDLivelyButtonStyleHamburger animated:YES];
        _exerciseName = dataItem.name;
    } else {
        [addExerciseButton setStyle:kFRDLivelyButtonStyleCirclePlus animated:YES];
        _exerciseName = @"";
    }
    [addExerciseButton setNeedsDisplay];

    [self.treeView deselectRowForItem:item animated:YES];
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    
    //show "No Exercises" view when there aren't entries
    
    NSInteger level  = [self.treeView levelForCellForItem:item];
    
    NSString *detailText;
    NSString *customTitleText;
    
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    
    RADataObject *dataItem = item;
    
    if (dataItem.RADataObjectType == DESCRIPTION) {
        customTitleText = dataItem.name;
        detailText = dataItem.dateStr;
    } else if (dataItem.RADataObjectType == EXERCISE) {
        customTitleText = dataItem.name;
        [self.treeView expandRowForItem:item expandChildren:YES withRowAnimation:RATreeViewRowAnimationNone]; //expand all information
    } else if (dataItem.RADataObjectType == INFORMATION) {
        int weight = (int) dataItem.weight;
        if (weight == 0) {
            weight++; //never let the minimum weight be zero
        }
        detailText = [NSString stringWithFormat:@"%d %@, %d %@, %d %@", dataItem.sets, dataItem.sets == 1 ? @"set" : @"reps",dataItem.reps, dataItem.reps == 1 ? @"rep" : @"reps", weight, _unit];
    }
    
    [cell setupWithTitle:customTitleText detailText:detailText level:level RADataObjectType:dataItem.RADataObjectType];
    cell.backgroundColor = [UIColor ht_cloudsColor];
    
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    if (data.RADataObjectType == INFORMATION || data.RADataObjectType == DESCRIPTION) {
        return 0;
    } else {
        NSInteger numDifferentSets = [data.infoArray count];
        return numDifferentSets;
    }
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [self.data objectAtIndex:index];
    } else {
        RADataObject *data = item;
        if (data.RADataObjectType == INFORMATION || data.RADataObjectType == DESCRIPTION) {
            return data;
        } else {
            return data.infoArray[index];
        }
    }
}
@end
