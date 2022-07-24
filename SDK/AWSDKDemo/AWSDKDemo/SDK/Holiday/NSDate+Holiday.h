//
//  NSDate+Holiday.h
//  IOSFrame
//
//  Created by JuneCheng on 2019/8/1.
//  Copyright © 2019  ChengJun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Holiday)

/** 获取节日节气，节日优先 */
+ (NSString *)specialdDayFromDate:(NSDate *)date;

/** 获取节日节气，节日优先 */
+ (NSString *)specialdDayFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/** 节日 */
+ (NSString *)holiDayFromDate:(NSDate *)date;

/** 农历节日 */
+ (NSString *)lunarHolidayFromDate:(NSDate *)date;

/** 阳历节日 */
+ (NSString *)solarHolidayFromDate:(NSDate *)date;

/** 节气 */
+ (NSString *)solartermFromDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
