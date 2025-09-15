#import <YandexMapsMobile/YMKLocalizedValue.h>

/**
 * Quantitative characteristics of any segment of the route.
 */
@interface YMKDrivingWeight : NSObject

/**
 * Time to travel, not considering traffic.
 */
@property (nonatomic, readonly, nonnull) YMKLocalizedValue *time;

/**
 * Time to travel, considering traffic.
 */
@property (nonatomic, readonly, nonnull) YMKLocalizedValue *timeWithTraffic;

/**
 * Distance to travel.
 */
@property (nonatomic, readonly, nonnull) YMKLocalizedValue *distance;


+ (nonnull YMKDrivingWeight *)weightWithTime:(nonnull YMKLocalizedValue *)time
                             timeWithTraffic:(nonnull YMKLocalizedValue *)timeWithTraffic
                                    distance:(nonnull YMKLocalizedValue *)distance;


@end
