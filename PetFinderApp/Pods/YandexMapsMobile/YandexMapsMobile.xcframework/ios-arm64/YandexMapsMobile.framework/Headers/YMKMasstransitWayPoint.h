#import <YandexMapsMobile/YMKPoint.h>

/**
 * A waypoint is the origin, destination or intermediate destination on
 * the route. For each waypoint, the corresponding selected arrival
 * point can be stored.
 */
@interface YMKMasstransitWayPoint : NSObject

/**
 * Coordinates of the original waypoint from the request.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *position;

/**
 * Coordinates of the arrival point that was selected for arrival at the
 * waypoint.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKPoint *selectedArrivalPoint;

/**
 * Coordinates of the arrival point that was selected for departure from
 * the waypoint.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKPoint *selectedDeparturePoint;

/**
 * request's context for this point
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *context;

/**
 * Indoor level (floor) id
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *levelId;

/**
 * Indoor level (floor) name
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *levelName;


+ (nonnull YMKMasstransitWayPoint *)wayPointWithPosition:(nonnull YMKPoint *)position
                                    selectedArrivalPoint:(nullable YMKPoint *)selectedArrivalPoint
                                  selectedDeparturePoint:(nullable YMKPoint *)selectedDeparturePoint
                                                 context:(nullable NSString *)context
                                                 levelId:(nullable NSString *)levelId
                                               levelName:(nullable NSString *)levelName;


@end
