#import <YandexMapsMobile/YMKMasstransitFlags.h>
#import <YandexMapsMobile/YMKMasstransitTravelEstimation.h>
#import <YandexMapsMobile/YMKMasstransitWeight.h>

/**
 * Contains brief information associated with a route constructed by the
 * mass transit router.
 */
@interface YMKMasstransitSummary : NSObject

/**
 * Contains the route time, distance of the walking part, and the number
 * of transfers.
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitWeight *weight;

/**
 * Arrival and departure time estimations for time-dependent routes.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitTravelEstimation *estimation;

/**
 * Specific properties of the route.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitFlags *flags;


+ (nonnull YMKMasstransitSummary *)summaryWithWeight:(nonnull YMKMasstransitWeight *)weight
                                          estimation:(nullable YMKMasstransitTravelEstimation *)estimation
                                               flags:(nullable YMKMasstransitFlags *)flags;


@end
