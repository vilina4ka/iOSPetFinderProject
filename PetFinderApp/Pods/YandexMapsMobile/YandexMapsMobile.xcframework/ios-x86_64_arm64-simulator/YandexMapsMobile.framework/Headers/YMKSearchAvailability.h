#import <Foundation/Foundation.h>

/**
 * A group of week days.
 */
typedef NS_OPTIONS(NSUInteger, YMKSearchDayGroup) {
    /**
     * Nothing.
     */
    YMKSearchDayGroupNone = 0,
    /**
     * Sunday.
     */
    YMKSearchDayGroupSunday = 1,
    /**
     * Monday.
     */
    YMKSearchDayGroupMonday = 1 << 1,
    /**
     * Tuesday.
     */
    YMKSearchDayGroupTuesday = 1 << 2,
    /**
     * Wednesday.
     */
    YMKSearchDayGroupWednesday = 1 << 3,
    /**
     * Thursday.
     */
    YMKSearchDayGroupThursday = 1 << 4,
    /**
     * Friday.
     */
    YMKSearchDayGroupFriday = 1 << 5,
    /**
     * Saturday.
     */
    YMKSearchDayGroupSaturday = 1 << 6,
    /**
     * Weekdays from Monday to Friday.
     */
    YMKSearchDayGroupWeekdays = YMKSearchDayGroupMonday | YMKSearchDayGroupTuesday | YMKSearchDayGroupWednesday | YMKSearchDayGroupThursday | YMKSearchDayGroupFriday,
    /**
     * Weekend days (Saturday and Sunday)
     */
    YMKSearchDayGroupWeekend = YMKSearchDayGroupSaturday | YMKSearchDayGroupSunday,
    /**
     * Every day of the week
     */
    YMKSearchDayGroupEveryday = YMKSearchDayGroupWeekdays | YMKSearchDayGroupWeekend
};

/**
 * The time interval used to compose availability info.
 *
 * Can describe two kinds of intervals: 1. 24-hour interval
 * (`isTwentyFourHours` is true, `from` and `to` are not used). 2.
 * Smaller time interval (`isTwentyFourHours` is false, `from` and `to`
 * are set to the begin and end of the interval)
 */
@interface YMKSearchTimeRange : NSObject

/**
 * All day (24 hours) time range marker.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *isTwentyFourHours;

/**
 * Interval start (seconds from midnight).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *from;

/**
 * Interval end (seconds from midnight).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *to;


+ (nonnull YMKSearchTimeRange *)timeRangeWithIsTwentyFourHours:(nullable NSNumber *)isTwentyFourHours
                                                          from:(nullable NSNumber *)from
                                                            to:(nullable NSNumber *)to;


@end

/**
 * A single value of availability information.
 *
 * Allows to describe business schedule for a group of days. For
 * example, an organization open on weekdays from 9 AM to 6 PM with a
 * lunch break from 1 PM to 2 PM can be described as a single
 * `Availability` with `days` equal to `DayGroup::Weekdays` and two time
 * ranges (9:00-13:00, 14:00-18:00). More complicated schedules will
 * require multiple `Availabilities`.
 */
@interface YMKSearchAvailability : NSObject

/**
 * Days where time ranges are applicable
 */
@property (nonatomic, readonly) YMKSearchDayGroup days;

/**
 * Ranges for open hours
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchTimeRange *> *timeRanges;


+ (nonnull YMKSearchAvailability *)availabilityWithDays:( YMKSearchDayGroup)days
                                             timeRanges:(nonnull NSArray<YMKSearchTimeRange *> *)timeRanges;


@end
