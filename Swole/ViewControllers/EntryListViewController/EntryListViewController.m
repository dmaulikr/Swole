//
//  EntryListViewController.m
//  Swole
//
//  Created by gamaux01 on 2015/6/18.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//


#import "EntryListViewController.h"
#import "NSDate+FSExtension.h"
#import "SpringTableViewCell.h"

@interface EntryListViewController () {
    CGRect screenFrame;
    CGRect calendarFrame;
    CGRect descriptionOutFrame;
    CGRect descriptionInFrame;
    CGRect configurationButtonFrame;
    CGRect deleteEntryButtonFrame;
    CGFloat descriptionHeight;
    CGFloat descriptionWidth;
    
    NSDate *selectedDate;
}

@property SpringTableViewCell *springCell;
@property UIBarButtonItem *configurationBarButton;
@property NSString *currentDate;
@property NSString *todayDate;


// loading views
- (void) loadFrames;
- (void) loadDescriptionTableView;
- (void) loadCalendar;
- (void) loadCalendarAppearance;
- (void) loadConfigurationButton;

- (void) scrollToDate: (NSDate *) date AndSelect:(BOOL) select;
- (void) showAddEntryAlertView;
- (void) showEntryView:(NSString *)dateStr;
- (void) saveToUserDefaults;
- (void) loadFromUserDefaults;

@end

@implementation EntryListViewController

#pragma mark - EntryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //entryList
    [self loadFromUserDefaults];
    if (self.entryList == nil) {
        self.entryList = [[EntryList alloc] init];
    }
    self.entries = [self.entryList entries];

    //load components
    [self loadNavigationBarTitle];
    [self loadNavigationBarBackButton];
    [self loadFrames];
    [self loadCalendar];
    [self loadCalendarAppearance];
    [self loadDescriptionTableView];
    [self loadConfigurationButton];
    [self loadDeleteEntryButton];
    
    //always pick today when you load the view
    self.calendar.selectedDate = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self calendar: _calendar hasEventForDate: _calendar.selectedDate] ) {
        [self slideDescriptionIn];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self slideDescriptionOut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loading methods

- (void) loadNavigationBarTitle {
    //navigation bar title
    
    SpringButton *titleButton = [[SpringButton alloc] initWithFrame: CGRectMake(0, 0, 10, 0)];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString: @"Swole"];
    NSDictionary *fontAttributes =   [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"AvenirNext-Regular" size:30.f],
                                      NSFontAttributeName, nil];
    [titleString setAttributes:fontAttributes range:NSMakeRange(0, [titleString length])];
    [titleButton setAttributedTitle: titleString forState: UIControlStateNormal];
    titleButton.titleLabel.textColor = [UIColor whiteColor];
    [titleButton addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchDown];
    [self.navigationItem setTitleView:titleButton];
}

- (void) loadNavigationBarBackButton {
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}

- (void) loadFrames {
    screenFrame = [[UIScreen mainScreen] bounds];
    calendarFrame = CGRectMake(5, 0, screenFrame.size.width - 10, screenFrame.size.height * .65f);
    descriptionWidth = screenFrame.size.width - 20;
    descriptionHeight = screenFrame.size.height * .4f;
    descriptionOutFrame = CGRectMake(10, screenFrame.size.height, descriptionWidth, descriptionHeight);
    descriptionInFrame = CGRectMake(10, calendarFrame.size.height + 10, descriptionWidth, descriptionHeight);
    configurationButtonFrame = CGRectMake(0, 0, 45, 0);
    deleteEntryButtonFrame = CGRectMake(descriptionInFrame.size.width * .94f, descriptionInFrame.origin.y , 30, 30); //color is #585858
}

- (void) loadCalendar {
    self.calendar = [[FSCalendar alloc] initWithFrame:calendarFrame];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    self.calendar.entryListViewControllerDelegate = self;
    [self.view addSubview: self.calendar];
}

- (void)loadCalendarAppearance {
    self.calendar.appearance.headerDateFormat = @"MMM yyyy";
    self.calendar.appearance.weekdayTextColor = [UIColor blackColor];
    self.calendar.appearance.headerTitleColor = [UIColor blackColor];
    self.calendar.appearance.selectionColor = [UIColor ht_bitterSweetColor];
    self.calendar.appearance.eventColor = [UIColor ht_silverColor];
    self.calendar.appearance.todayColor = [UIColor ht_cloudsColor];
    self.calendar.flow = FSCalendarFlowVertical;

}

- (void) loadDescriptionTableView {
    self.descriptionTableView = [[UITableView alloc] initWithFrame:descriptionOutFrame];
    self.descriptionTableView.delegate = self;
    self.descriptionTableView.dataSource = self;
    self.descriptionTableView.layer.cornerRadius = 5;
    [self.view addSubview: self.descriptionTableView];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, descriptionInFrame.size.width, descriptionInFrame.size.height *.3f)];
    footerView.backgroundColor = [UIColor ht_cloudsColor];
    self.descriptionTableView.tableFooterView = footerView;
}

- (void) loadConfigurationButton {
    SpringButton *configurationButton = [[SpringButton alloc] initWithFrame: configurationButtonFrame];
    [configurationButton setTitle: @"\u2699" forState: UIControlStateNormal];
    configurationButton.titleLabel.font = [UIFont fontWithName: @"AvenirNext-Regular" size: 45.f];
    [configurationButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [configurationButton addTarget:self action:@selector(spin:) forControlEvents: UIControlEventTouchDown];
    //test
//    [configurationButton addTarget:self action:@selector(showEntryView2) forControlEvents:UIControlEventTouchDown];
    
    self.configurationBarButton = [[UIBarButtonItem alloc] initWithCustomView: configurationButton];
    [self.navigationItem setRightBarButtonItem: self.configurationBarButton animated:YES];
}

- (void) loadDeleteEntryButton {
    self.deleteEntryButton = [[UIButton alloc] initWithFrame:deleteEntryButtonFrame];
    [self.deleteEntryButton setTitle:@"X" forState:UIControlStateNormal];//this is how you set the title text
    self.deleteEntryButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:20.f];
    [self.deleteEntryButton addTarget:self action:@selector(doDeleteEntryButton) forControlEvents:UIControlEventTouchUpInside];
    self.deleteEntryButton.hidden = YES;
    [self.view addSubview:self.deleteEntryButton];
    
}

#pragma mark - Animations

- (void) slideDescriptionIn {
    [UIView animateWithDuration:.3f delay:.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.descriptionTableView.frame = descriptionInFrame;
    }completion:nil ];
    self.deleteEntryButton.hidden = NO;
    [self.descriptionTableView reloadData];
}

- (void) slideDescriptionOut {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.descriptionTableView.frame = descriptionOutFrame;
    [UIView commitAnimations];
    self.deleteEntryButton.hidden = YES;
}

#pragma mark - EntryListViewControllerDelegate

- (void)animateEntryListViewLabels {
    self.springCell.mainLabel.animation = @"fadeInUp";
    self.springCell.mainLabel.curve = @"easeIn";
    self.springCell.mainLabel.duration = .8f;
    self.springCell.mainLabel.force = .5f;
    [self.springCell.mainLabel animate];
}

- (void) doCellButton {
    if ([self calendar:self.calendar hasEventForDate: [DataElementHelper stringToDate: self.currentDate]]) {
        [self showEntryView: self.currentDate];
    } else {
        [self showAddEntryAlertView];
    }
}

- (NSString *) getCurrentDate {
    return self.currentDate;
}

- (EntryList *) getEntryList {
    return self.entryList;
}

- (NSMutableDictionary *) entriesByEntryName {
    return [_entryList entriesByEntryName];
}

- (void) toggleDefaultSystemOfMeasurement {
    [_entryList toggleSystem];
    [self saveToUserDefaults];
}

- (SystemOfMeasurement) systemOfMeasurement {
    return [_entryList defaultSystemOfMeasurement];
}
    //close alertview
- (void)dismissExerciseAlertView {
    [_entryAlertView close];
}

- (void) scrollToDate: (NSDate *) date AndSelect:(BOOL) select {
    if (select) {
        _calendar.selectedDate = date;
    } else {
        [_calendar scrollToDate:date animate:YES];
    }
}

    //save entry, close alert view for confirm button
- (void)addEntryToEntryList:(Entry *)entry{
    //add entry to entry list
    [self.entryList addEntry:entry date:[entry dateStr]];
    [self saveToUserDefaults]; //save
    [self.descriptionTableView reloadData];
    
    //set-up views
    [self.entryAlertView close];
    EntryViewController2 *entryViewController2 = [[EntryViewController2 alloc] initWithNibName:@"EntryViewController2" bundle:nil WithEntry:entry];
    entryViewController2.entryListViewControllerDelegate = self;
    [self.navigationController pushViewController:entryViewController2 animated:NO];
    [self.calendar reloadData];//update calendar
}

- (void) deleteAndSaveEntryWithDate:(NSString *)date {
    [self.entryList deleteEntry:date];
    [self saveToUserDefaults];
}

- (void) addAndSaveEntry:(Entry *)entry date:(NSString *)date {
    [self.entryList addEntry:entry date:date];
    [self saveToUserDefaults];
}

- (void)loadFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *objectData = [defaults objectForKey:@"entryList"];
    if(objectData != nil)
    {
        self.entryList = [NSKeyedUnarchiver
                      unarchiveObjectWithData:objectData];
    }
}

- (void)saveToUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_entryList] forKey:@"entryList"];
    [defaults synchronize];
}

#pragma mark - Button Actions

- (void) doDeleteEntryButton {
    [self deleteAndSaveEntryWithDate:self.currentDate];
    [self slideDescriptionOut];
    [self.calendar reloadData];
}

- (void) spin: (id) sender {
    SpringButton *springButton = (SpringButton *)sender;
    springButton.animation = @"swing";
    springButton.curve = @"easeIn";
    springButton.force = .5f;
    springButton.duration = .5f;
    [springButton animate];    
}

- (void) clickTitle: (id) sender{
    [self scrollToDate: [NSDate date] AndSelect:YES];
    SpringButton *titleView = (SpringButton *)sender;
    titleView.animation = @"pop";
    titleView.curve = @"easeIn";
    titleView.force = 1.8f;
    titleView.duration = .5f;
    [titleView animate];
}

#pragma mark - Navigation

- (void)showAddEntryAlertView{
    //alert view, addEntry view controller
    self.entryAlertView = [[CustomIOSAlertView alloc] init];
    self.addEntryAlertViewController =  [[AddEntryAlertViewController alloc] initWithNibName:@"AddEntryAlertViewController" bundle:nil];
    self.addEntryAlertViewController.entryListViewControllerDelegate = self;
    [self.addEntryAlertViewController setDateString: self.currentDate];
    
    //put addEntryAlertView into alert view
    self.entryAlertView.containerView = self.addEntryAlertViewController.view;
    self.entryAlertView.buttonTitles = nil;
    self.entryAlertView.useMotionEffects = YES;
    [self.entryAlertView show];
}

- (void)showEntryView:(NSString *)dateStr{
    Entry *entry = self.entries[dateStr];
    
    EntryViewController2 *entryViewController2 = [[EntryViewController2 alloc] initWithNibName:@"EntryViewController2" bundle:nil WithEntry:entry];
    //set entry and delegate
    entryViewController2.entryListViewControllerDelegate = self;
    [self.navigationController pushViewController:entryViewController2 animated:YES];
}

//test
- (void)showEntryView2{
    EntryViewController2 *entryViewController2 = [[EntryViewController2 alloc] initWithNibName:@"EntryViewController2" bundle:nil];
//    
//    NSMutableDictionary *entries = [_entryList entries];
//    Entry *entry = entries[dateStr];
//    
//    entryViewController2.entry = entry;
    [self.navigationController pushViewController:entryViewController2 animated:YES];

}
/**
 *  Description.
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //deselect the cell immediately after selection
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //click on the cell to go to its view
    SpringTableViewCell *cell = (SpringTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (![cell.date isEqualToString: @""]) {
        [self showEntryView:cell.date];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return screenFrame.size.height *.21f;
    } else {
        return screenFrame.size.height *.07f;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Entry *entry = self.entries[self.currentDate];
    return [entry.exercises count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //set up cells with object pooling
    static NSString *cellIdentifier = @"SpringTableViewCell";
    SpringTableViewCell *cell = (SpringTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {//create a cell using a custom class
        [tableView registerNib: [UINib nibWithNibName:@"SpringTableViewCell" bundle:nil]  forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    //loads text onto  cells
    NSArray *dates = [_entryList dates];

    cell.date = self.currentDate; //save the current date into the cell

    if ([dates containsObject:self.currentDate]) {
        if (indexPath.row == 0) {
            cell.mainLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:40];
            Entry *currentEntry = self.entries[self.currentDate];
            cell.mainLabel.text = [NSString stringWithFormat:@"%@", [currentEntry entryName]];
            cell.mainLabel.textAlignment = NSTextAlignmentLeft;
            self.springCell = cell; //only animate the description cell
        } else {
            cell.mainLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:20];
            NSMutableDictionary *exercises = [self.entry exercises];
            NSMutableArray *exerciseNames = [self.entry exerciseNames];
            NSString *exerciseName = exerciseNames[indexPath.row - 1];
            NSUInteger numberOfExercises = [exercises[exerciseName] count];
            NSString *numberOfExercisesString = numberOfExercises != 1 ? [NSString stringWithFormat: @", %d sets", numberOfExercises ] : @", 1 set";
            cell.mainLabel.text = [NSString stringWithFormat:@"  \u2219 %@ %@",  exerciseName, numberOfExercises == 0 ? @"" : numberOfExercisesString];
            cell.mainLabel.textAlignment = NSTextAlignmentLeft;


        }
    }
    
    cell.backgroundColor = [UIColor ht_cloudsColor];
    return cell;
}

//deleting cells
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/**
 *  Calendar.
 */

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    //select new date
    self.currentDate = [date fs_stringWithFormat:@"yyyy-MM-dd"];
    self.entry = self.entries[self.currentDate];
    [self.descriptionTableView reloadData];

    //if you are selecting today
    if ([DataElementHelper isDateA: date EqualToDateB: [NSDate date]]) {
        self.calendar.appearance.selectionColor = [UIColor ht_bitterSweetDarkColor];
    } else {
        self.calendar.appearance.selectionColor = [UIColor ht_bitterSweetColor];
    }
    if ([self calendar:self.calendar hasEventForDate:date]) {
        [self slideDescriptionIn];
    } else {
        [self slideDescriptionOut];
        
    }
}
#pragma mark - FSCalendarDataSource

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    NSMutableArray *dates = [_entryList dates];
    NSString *dateStr = [date fs_stringWithFormat:@"yyyy-MM-dd"];
    return [dates containsObject:dateStr];
}

@end
