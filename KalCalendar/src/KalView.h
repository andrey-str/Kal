/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import "KalWeekStripView.h"
#import "KalGridView.h"


@class KalLogic;
@protocol KalViewDelegate, KalDataSourceCallbacks;

/*
 *    KalView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalViewController).
 *
 *  KalViewController uses KalView as its view.
 *  KalView defines a view hierarchy that looks like the following:
 *
 *       +-----------------------------------------+
 *       |                header view              |
 *       +-----------------------------------------+
 *       |                                         |
 *       |                                         |
 *       |                                         |
 *       |                 grid view               |
 *       |             (the calendar grid)         |
 *       |                                         |
 *       |                                         |
 *       +-----------------------------------------+
 *       |                                         |
 *       |           table view (events)           |
 *       |                                         |
 *       +-----------------------------------------+
 *
 */

typedef enum {
    eKalViewMode_MIN = 0,
    eMonthView,
    eWeekView,
    eDaysView,
    eKalViewMode_MAX
} eKalViewMode;

@interface KalView : UIView
{
  UILabel *headerTitleLabel;
  KalLogic *logic;
}

@property (nonatomic, weak) id<KalViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KalWeekStripView * weekView;
@property (nonatomic, strong) KalGridView *gridView;
@property (nonatomic, assign) eKalViewMode viewMode;
@property (nonatomic, assign) BOOL animateModeSwitching;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)delegate logic:(KalLogic *)logic;
- (BOOL)isSliding;
- (void)markTilesForDates:(NSArray *)dates;
- (void)redrawEntireMonth;
- (void) setUpConstraints;
// These 3 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the month specified by the user.
- (void)slideDown;
- (void)slideUp;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")

@end

#pragma mark -

@protocol KalViewDelegate

@optional

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (void)didSelectDate:(NSDate *)date;
- (void)didSelectBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;

@end
