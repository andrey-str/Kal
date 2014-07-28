/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalLogic.h"
#import "KalPrivate.h"
#import "NSDate+Convenience.h"

@interface KalLogic ()

- (void)moveToMonthForDate:(NSDate *)date;
- (void)recalculateVisibleDays;
- (NSUInteger)numberOfDaysInPreviousPartialWeek;
- (NSUInteger)numberOfDaysInFollowingPartialWeek;

@end

@implementation KalLogic

+ (NSSet *)keyPathsForValuesAffectingSelectedMonthNameAndYear
{
    return [NSSet setWithObjects:@"baseDate", nil];
}

- (id)initForDate:(NSDate *)date
{
    if ((self = [super init])) {
        monthAndYearFormatter = [[NSDateFormatter alloc] init];
        [monthAndYearFormatter setDateFormat:NSLocalizedString(@"CalendarTitle", @"")];
        [self moveToMonthForDate:date];
    }
    return self;
}

- (id)init
{
    return [self initForDate:[NSDate date]];
}

- (void)moveToMonthForDate:(NSDate *)date
{
    self.baseDate = [date cc_dateByMovingToFirstDayOfTheMonth];
    self.dateOfInterest = date;
    [self recalculateVisibleDays];
}

- (void)retreatToPreviousMonth
{
    [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth]];
}

- (void)advanceToFollowingMonth
{
    [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth]];
}

- (NSString *)selectedMonthNameAndYear;
{
    return [monthAndYearFormatter stringFromDate:self.baseDate];
}

#pragma mark Low-level implementation details

- (NSUInteger)numberOfDaysInPreviousPartialWeek
{
    unsigned long num = [self.baseDate cc_weekday] - 1;
    if (num == 0)
        num = 7;
    return num;
}

- (NSUInteger)numberOfDaysInFollowingPartialWeek
{
    NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
    c.day = [self.baseDate cc_numberOfDaysInMonth];
    NSDate *lastDayOfTheMonth = [[NSCalendar currentCalendar] dateFromComponents:c];
    unsigned long num = 7 - [lastDayOfTheMonth cc_weekday];
    if (num == 0)
        num = 7;
    return num;
}

- (NSArray *)calculateDaysInFinalWeekOfPreviousMonth
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSDate *beginningOfPreviousMonth = [self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth];
    NSUInteger n = [beginningOfPreviousMonth cc_numberOfDaysInMonth];
    NSUInteger numPartialDays = [self numberOfDaysInPreviousPartialWeek];
    NSDateComponents *c = [beginningOfPreviousMonth cc_componentsForMonthDayAndYear];
    for (NSUInteger i = n - (numPartialDays - 1); i < n + 1; i++)
        [days addObject:[NSDate dateForDay:i month:c.month year:c.year]];
    
    return days;
}

- (NSArray *)calculateDaysInSelectedWeek
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSDateComponents* c = [self.dateOfInterest cc_componentsForMonthWeekDayAndYear];
    
    for (int i = -5; i <  5 + 5; ++i) {
        [days addObject:[NSDate dateForDay:(c.day + i) month:c.month year:c.year]];
    }
    
    return days;
}

- (NSArray *)calculateDaysInSelectedMonth
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSUInteger numDays = [self.baseDate cc_numberOfDaysInMonth];
    NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
    for (int i = 1; i < numDays + 1; i++)
        [days addObject:[NSDate dateForDay:i month:c.month year:c.year]];
    
    return days;
}

- (NSArray *)calculateDaysInFirstWeekOfFollowingMonth
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSDateComponents *c = [[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth] cc_componentsForMonthDayAndYear];
    NSUInteger numPartialDays = [self numberOfDaysInFollowingPartialWeek];
    
    for (int i = 1; i < numPartialDays + 1; i++)
        [days addObject:[NSDate dateForDay:i month:c.month year:c.year]];
    
    return days;
}

- (void)recalculateVisibleDays
{
    _daysInSelectedWeek = [self calculateDaysInSelectedWeek];
    _daysInSelectedMonth = [self calculateDaysInSelectedMonth];
    _daysInFinalWeekOfPreviousMonth = [self calculateDaysInFinalWeekOfPreviousMonth];
    _daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonth];
    NSDate *from = [self.daysInFinalWeekOfPreviousMonth count] > 0 ? [self.daysInFinalWeekOfPreviousMonth objectAtIndex:0] : [self.daysInSelectedMonth objectAtIndex:0];
    NSDate *to = [self.daysInFirstWeekOfFollowingMonth count] > 0 ? [self.daysInFirstWeekOfFollowingMonth lastObject] : [self.daysInSelectedMonth lastObject];
    _fromDate = [from cc_dateByMovingToBeginningOfDay];
    _toDate = [to cc_dateByMovingToEndOfDay];
}

#pragma mark -


@end
