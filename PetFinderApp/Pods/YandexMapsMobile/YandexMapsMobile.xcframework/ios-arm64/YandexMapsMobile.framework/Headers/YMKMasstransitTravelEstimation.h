#import <YandexMapsMobile/YMKTime.h>

/**
 * Arrival and departure time estimations for time-dependent routes or
 * sections of time-dependent routes.
 */
@interface YMKMasstransitTravelEstimation : NSObject

/**
 * Departure time for a route or a route section.
 */
@property (nonatomic, readonly, nonnull) YMKTime *departureTime;

/**
 * Arrival time for a route or a route section.
 */
@property (nonatomic, readonly, nonnull) YMKTime *arrivalTime;


+ (nonnull YMKMasstransitTravelEstimation *)travelEstimationWithDepartureTime:(nonnull YMKTime *)departureTime
                                                                  arrivalTime:(nonnull YMKTime *)arrivalTime;


@end
