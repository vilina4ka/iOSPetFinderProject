#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YMKPoint.h>

/**
 * Via points (throughpoints) are key points on the route geometry that
 * the route passes through. Via points are taken from the request.
 */
@interface YMKBicycleViaPoint : NSObject

/**
 * Via point position on the route geometry.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;


+ (nonnull YMKBicycleViaPoint *)viaPointWithPosition:(nonnull YMKPolylinePosition *)position;


@end

/**
 * A waypoint is the origin, destination or intermediate destination on
 * the route. For each way point, the corresponding selected arrival
 * point can be stored.
 */
@interface YMKBicycleWayPoint : NSObject

/**
 * Coordinates of the original waypoint from the request.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *position;

/**
 * Coordinates of the selected arrival point.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKPoint *selectedArrivalPoint;


+ (nonnull YMKBicycleWayPoint *)wayPointWithPosition:(nonnull YMKPoint *)position
                                selectedArrivalPoint:(nullable YMKPoint *)selectedArrivalPoint;


@end
