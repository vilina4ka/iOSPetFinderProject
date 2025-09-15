#import <YandexMapsMobile/YMKLocalizedValue.h>

/**
 * Quantitative characteristics of a route or route section.
 */
@interface YMKBicycleWeight : NSObject

/**
 * Time to travel.
 */
@property (nonatomic, readonly, nonnull) YMKLocalizedValue *time;

/**
 * Distance to travel.
 */
@property (nonatomic, readonly, nonnull) YMKLocalizedValue *distance;


+ (nonnull YMKBicycleWeight *)weightWithTime:(nonnull YMKLocalizedValue *)time
                                    distance:(nonnull YMKLocalizedValue *)distance;


@end
