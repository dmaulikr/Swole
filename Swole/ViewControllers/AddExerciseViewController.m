//
//  AddExerciseViewController.m
//  Swole
//
//  Created by Victor on 8/7/15.
//  Copyright (c) 2015 Victor's Personal Projects. All rights reserved.
//

#import "AddExerciseViewController.h"

@interface AddExerciseViewController ()

@end

@implementation AddExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    CGRect screenFrame = [[UIScreen mainScreen] bounds];
//    self.searchResultsTableView.frame = screenFrame;
    
    //http://useyourloaf.com/blog/2015/02/16/updating-to-the-ios-8-search-controller.html
    self.searchResultsTableView.delegate = self;
    self.searchResultsTableView.dataSource = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil]; //When creating the search controller we do not need a separate search results controller as we will use the table view controller itself.
    self.searchController.searchResultsUpdater = self; //Likewise we will also use the table view controller to update the search results by having it implement the UISearchResultsUpdating protocol.
    self.searchController.dimsBackgroundDuringPresentation = NO; //We do not want to dim the underlying content as we want to show the filtered results as the user types into the search bar.
    self.searchController.searchBar.scopeButtonTitles = @[];//@[NSLocalizedString(@"ScopeButtonCountry",@"Country"), NSLocalizedString(@"ScopeButtonCapital",@"Capital")];
    
    
    //The UISearchController takes care of creating the search bar for us.
    self.searchController.searchBar.delegate = self; //The table view controller will also act as the search bar delegate for when the user changes the search scope.


    self.searchResultsTableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;

    [self.searchController.searchBar sizeToFit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper

//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    // update the filtered array based on the search text
//    NSString *searchText = searchController.searchBar.text;
//    NSMutableArray *searchResults = [self.products mutableCopy];
//    
//    // strip out all the leading and trailing spaces
//    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    // break up the search terms (separated by spaces)
//    NSArray *searchItems = nil;
//    if (strippedString.length > 0) {
//        searchItems = [strippedString componentsSeparatedByString:@" "];
//    }
//    
//    // build all the "AND" expressions for each value in the searchString
//    //
//    NSMutableArray *andMatchPredicates = [NSMutableArray array];
//    
//    for (NSString *searchString in searchItems) {
//        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
//        //
//        // example if searchItems contains "iphone 599 2007":
//        //      name CONTAINS[c] "iphone"
//        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
//        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
//        //
//        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
//        
//        // Below we use NSExpression represent expressions in our predicates.
//        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
//        
//        // name field matching
//        NSExpression *lhs = [NSExpression expressionForKeyPath:@"title"];
//        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
//        NSPredicate *finalPredicate = [NSComparisonPredicate
//                                       predicateWithLeftExpression:lhs
//                                       rightExpression:rhs
//                                       modifier:NSDirectPredicateModifier
//                                       type:NSContainsPredicateOperatorType
//                                       options:NSCaseInsensitivePredicateOption];
//        [searchItemsPredicate addObject:finalPredicate];
//        
//        // yearIntroduced field matching
//        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//        [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
//        NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
//        if (targetNumber != nil) {   // searchString may not convert to a number
//            lhs = [NSExpression expressionForKeyPath:@"yearIntroduced"];
//            rhs = [NSExpression expressionForConstantValue:targetNumber];
//            finalPredicate = [NSComparisonPredicate
//                              predicateWithLeftExpression:lhs
//                              rightExpression:rhs
//                              modifier:NSDirectPredicateModifier
//                              type:NSEqualToPredicateOperatorType
//                              options:NSCaseInsensitivePredicateOption];
//            [searchItemsPredicate addObject:finalPredicate];
//            
//            // price field matching
//            lhs = [NSExpression expressionForKeyPath:@"introPrice"];
//            rhs = [NSExpression expressionForConstantValue:targetNumber];
//            finalPredicate = [NSComparisonPredicate
//                              predicateWithLeftExpression:lhs
//                              rightExpression:rhs
//                              modifier:NSDirectPredicateModifier
//                              type:NSEqualToPredicateOperatorType
//                              options:NSCaseInsensitivePredicateOption];
//            [searchItemsPredicate addObject:finalPredicate];
//        }
//        
//        // at this OR predicate to our master AND predicate
//        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
//        [andMatchPredicates addObject:orMatchPredicates];
//    }
//    
//    // match up the fields of the Product object
//    NSCompoundPredicate *finalCompoundPredicate =
//    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
//    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
//    
//    // hand over the filtered results to our search results table
//    APLResultsTableController *tableController = (APLResultsTableController *)self.searchController.searchResultsController;
//    tableController.filteredProducts = searchResults;
//    [tableController.tableView reloadData];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    //set up cells with object pooling
    static NSString *cellIdentifier = @"Cell"; //different queues for different type of cells
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];//gets a cell from the queue
    
    if (cell == nil) { //creates a new one if the dequeue doesn't have any cells
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"Hi";

    return cell;
}




#pragma mark - UISearchResultsUpdating


// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
//    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
//    [self.tableView reloadData];
}

//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
//{
//    [self updateSearchResultsForSearchController:self.searchController];
//}

@end
