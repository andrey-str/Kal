/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <Foundation/Foundation.h>

/*
 *    KalLogic
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by the internal Kal subsystem).
 *
 *  The KalLogic represents the current state of the displayed calendar month
 *  and provides the logic for switching between months and determining which days
 *  are in a month as well as which days are in partial weeks adjacent to the selected
 *  month.
 *
 */
@interface KalLogic : NSObject
{
    NSDateFormatter *monthAndYearFormatter;
}

@property (nonatomic, strong) NSDate *baseDate;    // The first day of the currently selected month
@property (nonatomic, strong) NSDate *dateOfInterest; // Date determinate current week
@property (nonatomic, strong, readonly) NSDate *fromDate;  // The date corresponding to the tile in the upper-left corner of the currently selected month
@property (nonatomic, strong, readonly) NSDate *toDate;    // The date corresponding to the tile in the bottom-right corner of the currently selected month
@property (nonatomic, strong, readonly) NSArray *daysInSelectedMonth;             // array of NSDate
@property (nonatomic, strong, readonly) NSArray *daysInSelectedWeek;             // array of NSDate
@property (nonatomic, strong, readonly) NSArray *daysInFinalWeekOfPreviousMonth;  // array of NSDate
@property (nonatomic, strong, readonly) NSArray *daysInFirstWeekOfFollowingMonth; // array of NSDate
@property (copy, nonatomic, readonly) NSString *selectedMonthNameAndYear; // localized (e.g. "September 2010" for USA locale)

- (id)initForDate:(NSDate *)date; // designated initializer.

- (void)retreatToPreviousMonth;
- (void)advanceToFollowingMonth;
- (void)moveToMonthForDate:(NSDate *)date;

@end
