//
//  AnalysisViewController.m
//  Swole
//
//  Created by gamaux01 on 2015/7/8.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import "AnalysisViewController.h"

CGFloat const BarChartHeaderHeight = 80.0f;
CGFloat const BarChartFooterPadding = 5.0f;
CGFloat const BarChartFooterHeight = 25.0f;
CGFloat const BarChartPadding = 15.0f;


@interface AnalysisViewController ()


@end

@implementation AnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _weightBreakthroughDatesAndValuesArray = [DataElementHelper returnWeightBreakthroughDatesAndValuesForExercise:_exerciseName InEntryList:_entryList];
    _unit = [_entryList defaultSystemOfMeasurement] == METRIC ? @"kg" : @"lb";
    _colors = [[NSArray alloc] initWithObjects:[UIColor ht_citrusColor], [UIColor ht_mintDarkColor],[UIColor ht_lavenderDarkColor], [UIColor ht_aquaDarkColor], [UIColor ht_alizarinColor], nil];

    

    [self loadValueText];
    [self loadAnalyses];
    [self loadBarChart];
    [self loadHeader];
    [self loadFooter];
    [self loadInformationView];
    
    [_barChartView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set up

- (void)loadAnalyses {
    NSMutableArray *entriesWithExercise = _weightBreakthroughDatesAndValuesArray[[_weightBreakthroughDatesAndValuesArray count] - 1];
    _selectBarValueTextArray = [[NSMutableArray alloc] initWithObjects: nil];

    NSArray *dataArray;
    NSArray *textValueArray;
    int weight;
    NSString *datesSpent;
    NSString *firstDateStr;
    NSString *lastDateStr;
    NSString *maxSingleRepText;
    NSString *maxSingleRepOneSetText;
    
    
//    *  Index 0: first date
//    *  Index 1: most current date
//    *  Index 2: number of days you have exercised at this weight
//    *  Index 3: max single rep
//    *  Index 4: date for above
//    *  Index 5: max number of reps in a set
//    *  Index 6: date for above

    for (int i = 0; i < (int)[_weightBreakthroughDatesAndValuesArray count]/2; i++) {
        weight = [ _weightBreakthroughDatesAndValuesArray[i*2+1] intValue];
        dataArray = [DataElementHelper returnWeightBreakthroughAnalysisForExercise:_exerciseName Weight:weight InEntryArray:entriesWithExercise];
        datesSpent = [NSString stringWithFormat:@"Days spent on this weight: %@", dataArray[2]];
        firstDateStr = [NSString stringWithFormat:@"  First time: %@", dataArray[0]];
        lastDateStr = [NSString stringWithFormat:@"  Last time: %@", dataArray[1]];
        maxSingleRepText = [NSString stringWithFormat:@"Max reps, 1 set: %d on %@", [dataArray[3] intValue], dataArray[4]];
        maxSingleRepOneSetText = [NSString stringWithFormat:@"Max reps, 1 day: %d on %@", [dataArray[5] intValue], dataArray[6]];
        textValueArray = [[NSArray alloc] initWithObjects:datesSpent, firstDateStr, lastDateStr, maxSingleRepText, maxSingleRepOneSetText, nil];
        [_selectBarValueTextArray addObject:textValueArray];
    }
}

- (void)loadValueText {
    _defaultValueTextArray = [[NSMutableArray alloc] initWithObjects: nil];
    int counter = 0;
    NSNumber *weight;
    NSString *recordString;
    while (counter < (int)[_weightBreakthroughDatesAndValuesArray count]/2) {
        
        weight = _weightBreakthroughDatesAndValuesArray[counter*2 + 1];
        int intWeight = [weight intValue];
        if (intWeight == 0) {
            intWeight++;
        }
        
        recordString = [NSString stringWithFormat:@"%d %@ on %@", intWeight, _unit,  _weightBreakthroughDatesAndValuesArray[counter*2]];
        [_defaultValueTextArray addObject:recordString];
        counter++;
    }
}

- (void)loadBarChart {
    //    convenience
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = [UIColor ht_cloudsColor];
    
    _barChartView = [[JBBarChartView alloc] init];
    _barChartView.frame = CGRectMake(BarChartPadding, 10, screenFrame.size.width - BarChartPadding*2, screenFrame.size.height *.5f);
    _barChartView.minimumValue = 0;
    
    _barChartView.dataSource = self;
    _barChartView.delegate = self;
    _barChartView.backgroundColor = [UIColor ht_cloudsColor];
    
    [self.view addSubview:_barChartView];
}

- (void)loadHeader {
    _headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(BarChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(BarChartHeaderHeight * 0.5), self.view.bounds.size.width - (BarChartPadding * 2), BarChartHeaderHeight)];
    _headerView.titleLabel.text = _exerciseName;
    _headerView.subtitleLabel.text = @"Weight Breakthroughs";
    _headerView.separatorColor = [UIColor blackColor];
    self.barChartView.headerView = _headerView;
}

- (void)loadFooter {
    _footerView = [[JBBarChartFooterView alloc] initWithFrame:CGRectMake(BarChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(BarChartFooterHeight * 0.5), self.view.bounds.size.width - (BarChartPadding * 2), BarChartFooterHeight)];
    _footerView.padding = BarChartFooterPadding;
    _footerView.leftLabel.text = [_entryList defaultSystemOfMeasurement] == METRIC  ? @"KILOGRAMS" : @"POUNDS";
    self.barChartView.footerView = _footerView;
}


- (void)loadInformationView {
    _informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.barChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.barChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    [_informationView setTitleText:@"Breakthrough dates"];
    [_informationView setValueText: _defaultValueTextArray ];
    [_informationView setValueAndUnitTextColor:_colors];
    
    [_informationView setHidden:NO animated:YES];
    [self.view addSubview:_informationView];
}
#pragma mark - JBBarChartView Data Source

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    int numberOfBars = (int)[_weightBreakthroughDatesAndValuesArray count]/2;
    return numberOfBars;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
    _informationView.alpha = .5f;
    int weight = [_weightBreakthroughDatesAndValuesArray[index*2 + 1] intValue];
    [_informationView setTitleText: [NSString stringWithFormat:@"%d %@", weight, _unit]];
    [_informationView setTitleTextColor: _colors[index]];
    [_informationView setValueAndUnitTextColor: [[NSArray alloc] initWithObjects: [UIColor blackColor],[UIColor blackColor],[UIColor blackColor],[UIColor blackColor],[UIColor blackColor], nil] ];
    [_informationView setValueText: _selectBarValueTextArray[index]];
    [UIView animateWithDuration:.1f animations:^{
        _informationView.alpha = 1.f;
    }completion:nil];
}

- (void)didDeselectBarChartView:(JBBarChartView *)barChartView
{
    _informationView.alpha = .5f;
    [_informationView setTitleText:@"Breakthrough dates"];
    [_informationView setTitleTextColor:[UIColor blackColor]];
    [_informationView setValueAndUnitTextColor:_colors];
    [_informationView setValueText: _defaultValueTextArray];
    [UIView animateWithDuration:.1f animations:^{
        _informationView.alpha = 1.f;
    }completion:nil];
}

#pragma mark - JBBarChartView Delegate

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    NSNumber *height = _weightBreakthroughDatesAndValuesArray[index*2 + 1];
    int intHeight = [height intValue];
    if (intHeight == 0) {
        intHeight++;
    }
    return (CGFloat)intHeight;
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    return _colors[index];
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor ht_cloudsColor];
}

@end
