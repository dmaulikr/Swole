//
//  AnalysisViewController.h
//  Swole
//
//  Created by gamaux01 on 2015/7/8.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBBarChartView.h"
#import "JBChartHeaderView.h"
#import "JBBarChartFooterView.h"
#import "JBChartInformationView.h"
#import "UIColor+HTColor.h"
#import "DataElementHelper.h"


@interface AnalysisViewController : UIViewController <JBBarChartViewDataSource, JBBarChartViewDelegate> 

@property JBBarChartView *barChartView;
@property JBChartHeaderView *headerView;
@property JBBarChartFooterView* footerView;
@property JBChartInformationView* informationView;

@property EntryList *entryList;
@property NSString *exerciseName;
@property NSString *unit;

@property NSMutableArray *weightBreakthroughDatesAndValuesArray;
@property NSMutableDictionary *weightToAnalysisDictionary; //store the analysis in the key once it's made, so we don't have to make meaningless recalculations
@property NSMutableArray *defaultValueTextArray;
@property NSMutableArray *selectBarValueTextArray;
@property NSArray *colors;

- (void) loadValueText;
- (void)loadBarChart;
- (void)loadHeader;
- (void)loadFooter;
- (void)loadInformationView;

@end
