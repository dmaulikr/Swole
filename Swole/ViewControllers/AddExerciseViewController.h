//
//  AddExerciseViewController.h
//  Swole
//
//  Created by Victor on 8/7/15.
//  Copyright (c) 2015 Victor's Personal Projects. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddExerciseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTableView;

@end
