//
//  NSDate+Convenience.h
//  FiveStar
//
//  Created by Leon on 13-1-14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Convenience)

- (NSUInteger)year;
- (NSUInteger)month;
- (NSUInteger)day;
- (NSUInteger)hour;
- (NSString *)weekString;
- (NSDate *)offsetDay:(int)numDays;
- (BOOL)isToday;

+ (NSDate *)dateForDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year;
+ (NSDate *)dateStartOfDay:(NSDate *)date;
+ (int)dayBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSDate *)dateFromStringBySpecifyTime:(NSString *)dateString hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDateComponents *)nowDateComponents;
+ (NSDateComponents *)dateComponentsFromNow:(NSInteger)days;

@end
