//
//  FSCalendarCell.h
//  Pods
//
//  Created by Wenchao Ding on 12/3/15.
//
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "AddEntryAlertViewController.h"

@interface FSCalendarCell : UICollectionViewCell

@property (weak,   nonatomic) FSCalendarAppearance *appearance;

@property (strong, nonatomic) NSDate   *date;
@property (strong, nonatomic) NSDate   *month;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) UIImage  *image;

@property (weak,   nonatomic) UIButton *dateButton;
@property (weak,   nonatomic) UILabel  *subtitleLabel;

@property (assign, nonatomic) BOOL     hasEvent;

@property (readonly, getter = isPlaceholder) BOOL placeholder;
@property (assign, nonatomic) id<EntryListViewControllerDelegate> entryListViewControllerDelegate;

- (void)performSelecting;
- (void)performDeselecting;


@end
