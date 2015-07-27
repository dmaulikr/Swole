//
//  EntryListViewController.h
//  Swole
//
//  Created by gamaux01 on 2015/6/18.
//  Copyright (c) 2015年 Victor's Personal Projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AddEntryAlertViewController.h"
#import "FSCalendar.h"
#import "EntryViewController.h"
#import "EntryViewController2.h"
#import "UIElementHelper.h"
#import "Swole-Swift.h"

@interface EntryListViewController : UIViewController <EntryListViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate> {
}

@property UITableView *descriptionTableView;
@property NSArray *buttonArray;
@property CustomIOSAlertView *entryAlertView;
@property AddEntryAlertViewController *addEntryAlertViewController;
@property EntryList *entryList;
@property Entry *entry;
@property NSMutableDictionary *entries;

@property UIButton *deleteEntryButton;


@property FSCalendar *calendar;

@end
