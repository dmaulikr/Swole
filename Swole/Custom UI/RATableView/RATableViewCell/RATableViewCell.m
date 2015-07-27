
//
//Copyright (c) 2014 Rafał Augustyniak, Victor Lin
//

#import "RATableViewCell.h"

@interface RATableViewCell ()

@end

@implementation RATableViewCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  self.selectedBackgroundView = [UIView new];
  self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
  
}

- (void)prepareForReuse
{
  [super prepareForReuse];
}

- (void)setupWithTitle:(NSString *)title detailText:(NSString *)detailText level:(NSInteger)level RADataObjectType:(TypeOfRADataObject)RADataObjectType
{
    _RADataObjectType = RADataObjectType;
    CGRect cellBounds = CGRectMake(0, 0, 320, 40);
    CGRect detailedFrame = self.detailedLabel.frame;
    CGRect titleFrame = self.customTitleLabel.frame;
    
    self.backgroundColor = [UIColor whiteColor];
    self.customTitleLabel.text = title;
    self.detailedLabel.text = detailText;

    CGFloat indentation = cellBounds.size.height *.5f;
    titleFrame.origin.x = indentation;
    
    if (RADataObjectType == DESCRIPTION) {
        self.customTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:30];
        titleFrame.origin.y = cellBounds.size.height * .9f;
        titleFrame.size.height = cellBounds.size.height *.85f;
        titleFrame.size.width = cellBounds.size.width;

        self.detailedLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        detailedFrame = self.detailedLabel.frame;
        detailedFrame.origin.x = indentation;
        detailedFrame.origin.y = titleFrame.origin.y + titleFrame.size.height;
        detailedFrame.size.height = cellBounds.size.height *.55f;
        detailedFrame.size.width = cellBounds.size.width *.5f;
        
    } else if (RADataObjectType == EXERCISE) {
        self.detailedLabel.text = @"";
        self.customTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.f];
        titleFrame.origin.y = cellBounds.size.height * .25f;
        titleFrame.size.height = cellBounds.size.height *.55f;
        titleFrame.size.width = cellBounds.size.width - 50;
        
        //arrow image
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow Filled-32.png" ]];
        _arrow.frame = CGRectMake(cellBounds.origin.x + cellBounds.size.width - 35, cellBounds.size.height/2.f - 16, 32, 32);
        [self addSubview:_arrow];
        
    } else if (RADataObjectType == INFORMATION) {
        self.customTitleLabel.text = @"";
        self.detailedLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.f];
        detailedFrame.size.height = cellBounds.size.height *.55f;
        detailedFrame.size.width = cellBounds.size.width;
        detailedFrame.origin.x = cellBounds.origin.x + indentation + 10;
        detailedFrame.origin.y = cellBounds.size.height * .15f;
        
    }
    _arrow.alpha = 0.0f;
    _arrowHidden = YES;
    self.customTitleLabel.frame = titleFrame;
    self.detailedLabel.frame = detailedFrame;
}

#pragma mark - Properties

- (void)toggleArrow
{
    if (_RADataObjectType == EXERCISE) {
        _arrowHidden = !_arrowHidden;
        if (!_arrowHidden) {
            [UIView animateWithDuration:.3f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
            _arrow.alpha = 1.f;
            }completion:nil];
        } else {
            [UIView animateWithDuration:.3f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
                _arrow.alpha = 0.f;
            }completion:nil];
        }
    }
}

@end
