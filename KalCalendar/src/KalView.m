/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"
#import "../Extensions/UIView+UpdateAutoLayoutConstraints.h"

@interface KalView ()
{
    eKalViewMode _weekMode;
}
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;

@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UIView* contentView;
@end

static const CGFloat kHeaderHeight = 68.f;
static const CGFloat kMonthLabelHeight = 17.f;

@implementation KalView

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic
{
    if ((self = [super initWithFrame:frame])) {
        self.delegate = theDelegate;
        logic = theLogic;
        [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor colorWithRed:246.f/255.f green:246.f/255.f blue:246.f/255.f alpha:1.f];
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)];
        [self addSubviewsToHeaderView:_headerView];
        [self addSubview:_headerView];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubviewsToContentView: _contentView];
        [self addSubview: _contentView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
    return nil;
}

- (void)redrawEntireMonth { [self jumpToSelectedMonth]; }

- (void)slideDown { [self.gridView slideDown]; }
- (void)slideUp { [self.gridView slideUp]; }

- (void)showPreviousMonth
{
    if (!self.gridView.transitioning)
        [self.delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
    if (!self.gridView.transitioning)
        [self.delegate showFollowingMonth];
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
    const CGFloat kChangeMonthButtonWidth = 46.0f;
    const CGFloat kChangeMonthButtonHeight = 30.0f;
    const CGFloat kMonthLabelWidth = 200.0f;
    const CGFloat kHeaderVerticalAdjust = 13.f;
    
    // Create the previous month button on the left side of the view
    CGRect previousMonthButtonFrame = CGRectMake(self.left,
                                                 kHeaderVerticalAdjust,
                                                 kChangeMonthButtonWidth,
                                                 kChangeMonthButtonHeight);
    UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
    [previousMonthButton setAccessibilityLabel:NSLocalizedString(@"Previous month", nil)];
    [previousMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/kal_left_arrow.png"] forState:UIControlStateNormal];
    previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:previousMonthButton];
    
    // Draw the selected month name centered and at the top of the view
    CGRect monthLabelFrame = CGRectMake((self.width/2.0f) - (kMonthLabelWidth/2.0f),
                                        kHeaderVerticalAdjust,
                                        kMonthLabelWidth,
                                        kMonthLabelHeight);
    headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
    headerTitleLabel.backgroundColor = [UIColor clearColor];
    headerTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    headerTitleLabel.textAlignment = UITextAlignmentCenter;
    headerTitleLabel.textColor = [UIColor darkGrayColor];
    [self setHeaderTitleText:[logic selectedMonthNameAndYear]];
    [headerView addSubview:headerTitleLabel];
    
    // Create the next month button on the right side of the view
    CGRect nextMonthButtonFrame = CGRectMake(self.width - kChangeMonthButtonWidth,
                                             kHeaderVerticalAdjust,
                                             kChangeMonthButtonWidth,
                                             kChangeMonthButtonHeight);
    UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
    [nextMonthButton setAccessibilityLabel:NSLocalizedString(@"Next month", nil)];
    [nextMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/kal_right_arrow.png"] forState:UIControlStateNormal];
    nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:nextMonthButton];
    
    // Add column labels for each weekday (adjusting based on the current locale's first weekday)
    NSArray *weekdayNames = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
    NSArray *fullWeekdayNames = [[[NSDateFormatter alloc] init] standaloneWeekdaySymbols];
    NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
    NSUInteger i = firstWeekday - 1;
    for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += 46.f, i = (i+1)%7) {
        CGRect weekdayFrame = CGRectMake(xOffset, 30.f, 46.f, kHeaderHeight - 15.f);
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
        weekdayLabel.backgroundColor = [UIColor clearColor];
        weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        weekdayLabel.textAlignment = UITextAlignmentCenter;
        weekdayLabel.textColor = [UIColor grayColor];
        weekdayLabel.text = [weekdayNames objectAtIndex:i];
        [weekdayLabel setAccessibilityLabel:[fullWeekdayNames objectAtIndex:i]];
        [headerView addSubview:weekdayLabel];
    }
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
    // Both the tile grid and the list of events will automatically lay themselves
    // out to fit the # of weeks in the currently displayed month.
    // So the only part of the frame that we need to specify is the width.
    CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);
    
    self.weekView = [[KalWeekStripView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate: self.delegate];
    [self.weekView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    self.weekView.selectedDateBottomLineColor = [UIColor colorWithRed:0.98f green:0.70f blue:0.32f alpha:1.0f];
    [contentView addSubview:self.weekView];
    
    // The tile grid (the calendar body)
    self.gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:self.delegate];
    [self.gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [contentView addSubview:self.gridView];
    
    
    // The list of events for the selected day
    self.tableView = [[UITableView alloc] initWithFrame:fullWidthAutomaticLayoutFrame style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [contentView addSubview:self.tableView];
    
    // Trigger the initial KVO update to finish the contentView layout
    [self.gridView sizeToFit];

    
}

- (void) setViewMode:(eKalViewMode)viewMode{

    if(_viewMode == viewMode)
        return;
    
    _viewMode = viewMode;
    
    switch (_viewMode) {
        case eMonthView:
        {
            [self.headerView hideByHeight:NO];
            [self.gridView hideByHeight:NO];
            [self.weekView hideByHeight:YES];
        }
            break;
        case eWeekView:
        {
            [self.headerView hideByHeight:YES];
            [self.gridView hideByHeight:YES];
            [self.weekView hideByHeight:NO];
        }
            break;
        case eDaysView:
        {
            [self.headerView hideByHeight:YES];
            [self.gridView hideByHeight:YES];
            [self.weekView hideByHeight:YES];
            
        }
            break;
        default:
            break;
    }

    if(_animateModeSwitching){
        [UIView animateWithDuration:0.3f
                         animations:^{
                             
                             [self layoutIfNeeded];
                             
                         }];
    }
    
}

- (void) setUpConstraints
{
  //  self.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.gridView.translatesAutoresizingMaskIntoConstraints = NO;
    self.weekView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary* views = @{
                            @"headerView" :self.headerView,
                            @"contentView"   : self.contentView
                            };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[headerView]-0-[contentView]-0-|"
                                                                 options: NSLayoutFormatAlignAllCenterX
                                                                 metrics: nil
                                                                   views: views]];

    [self.headerView setConstraintConstant:self.headerView.frame.size.height forAttribute:NSLayoutAttributeHeight];
    [self.headerView setConstraintConstant:self.headerView.frame.size.width forAttribute:NSLayoutAttributeWidth];
    
    //[self.contentView setConstraintConstant:self.contentView.frame.size.height forAttribute:NSLayoutAttributeHeight];
    [self.contentView setConstraintConstant:self.contentView.frame.size.width forAttribute:NSLayoutAttributeWidth];
    
    NSDictionary* subViews = @{
                               @"gridView" : self.gridView,
                               @"weekView" : self.weekView,
                               @"tableView": self.tableView
                               };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[weekView]-0-[gridView]-0-[tableView]-0-|"
                                                                             options:NSLayoutFormatAlignAllCenterX
                                                                             metrics:nil
                                                                               views:subViews]];
    
    [self.weekView setConstraintConstant:self.weekView.frame.size.height forAttribute:NSLayoutAttributeHeight];
    [self.weekView setConstraintConstant:self.weekView.frame.size.width forAttribute:NSLayoutAttributeWidth];
    
    [self.gridView setConstraintConstant:self.gridView.frame.size.height forAttribute:NSLayoutAttributeHeight];
    [self.gridView setConstraintConstant:self.gridView.frame.size.width forAttribute:NSLayoutAttributeWidth];
    
//    [self.tableView setConstraintConstant:self.tableView.frame.size.height forAttribute:NSLayoutAttributeHeight];
    [self.tableView setConstraintConstant:self.tableView.frame.size.width forAttribute:NSLayoutAttributeWidth];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.gridView && [keyPath isEqualToString:@"frame"]) {
        
        /* Animate tableView filling the remaining space after the
         * gridView expanded or contracted to fit the # of weeks
         * for the month that is being displayed.
         *
         * This observer method will be called when gridView's height
         * changes, which we know to occur inside a Core Animation
         * transaction. Hence, when I set the "frame" property on
         * tableView here, I do not need to wrap it in a
         * [UIView beginAnimations:context:].
         */
        CGFloat gridBottom = self.gridView.top + self.gridView.height;
        CGRect frame = self.tableView.frame;
        frame.origin.y = gridBottom;
        frame.size.height = self.tableView.superview.height - gridBottom;
        self.tableView.frame = frame;
        
    } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
        [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
        
    } else {
        if (object != self.weekView) {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }

    }
}

- (void)setHeaderTitleText:(NSString *)text
{
    [headerTitleLabel setText:text];
    [headerTitleLabel sizeToFit];
    headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

- (void)jumpToSelectedMonth { [self.gridView jumpToSelectedMonth]; }

- (BOOL)isSliding { return self.gridView.transitioning; }

- (void)markTilesForDates:(NSArray *)dates {
    [self.gridView markTilesForDates:dates];
}

- (void)dealloc
{
    [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
    
    [self.gridView removeObserver:self forKeyPath:@"frame"];
}

- (eKalViewMode) weekMode{
    return _weekMode;
}


@end
