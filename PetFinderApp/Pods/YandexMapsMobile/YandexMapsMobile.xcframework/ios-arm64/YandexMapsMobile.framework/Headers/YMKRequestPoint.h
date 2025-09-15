#import <YandexMapsMobile/YMKPoint.h>

/**
 * The waypoint and a point the path must go through.
 */
typedef NS_ENUM(NSUInteger, YMKRequestPointType) {
    /**
     * The target waypoint.
     */
    YMKRequestPointTypeWaypoint,
    /**
     * A point the route must pass through.
     */
    YMKRequestPointTypeViapoint
};

/**
 * There are two types of request points. A waypoint is a destination.
 * Use it when you plan to stop there. Via points (throughpoints)
 * correct the route to make it pass through all the via points.
 * Waypoints are guaranteed to be between sections in the resulting
 * route. Via points are embedded into sections.
 *
 * For each request point, you can provide a point context. It's an
 * opaque string that describe entrances, driving arrival points and so
 * on. If such context is provided then a client will get routes to
 * those additional points.
 */
@interface YMKRequestPoint : NSObject

/**
 * The request point.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *point;

/**
 * The type of request point specified.
 */
@property (nonatomic, readonly) YMKRequestPointType type;

/**
 * Opaque string that describe entrances, driving arrival points and so
 * on.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *pointContext;

/**
 * Specifies what driving arrival point to use. If point is not
 * specified then server will select one.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *drivingArrivalPointId;

/**
 * Indoor level (floor) id
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *indoorLevelId;


+ (nonnull YMKRequestPoint *)requestPointWithPoint:(nonnull YMKPoint *)point
                                              type:( YMKRequestPointType)type
                                      pointContext:(nullable NSString *)pointContext
                             drivingArrivalPointId:(nullable NSString *)drivingArrivalPointId
                                     indoorLevelId:(nullable NSString *)indoorLevelId;


@end
