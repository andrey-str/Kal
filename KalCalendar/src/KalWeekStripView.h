//
//  Created by Dmitry Ivanenko on 14.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//
//  Modified for using with Kal calendar by Andrey Streltsov, 2014 andrey@anse.me

#import <UIKit/UIKit.h>

extern const NSTimeInterval kSecondsInDay;
extern const CGFloat kDIDetepickerHeight;

@class KalLogic;
@protocol KalViewDelegate;

@interface KalWeekStripView : UIView

// data
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic, readonly) NSDate *selectedDate;

// UI
@property (strong, nonatomic) UIColor *bottomLineColor;
@property (strong, nonatomic) UIColor *selectedDateBottomLineColor;

// methods
- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)theLogic delegate:(id<KalViewDelegate>)theDelegate;

- (void)fillDatesFromCurrentDate:(NSInteger)nextDatesCount;
- (void)fillDatesFromDate:(NSDate *)fromDate numberOfDays:(NSInteger)nextDatesCount;
- (void)fillCurrentWeek;
- (void)fillCurrentMonth;
- (void)fillCurrentYear;
- (void)selectDate:(NSDate *)date;
- (void)selectDateAtIndex:(NSUInteger)index;

@end
