#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YMKPoint.h>

@class YMKRoutePosition;

/**
 * Undocumented
 */
@interface YMKRoutePosition : NSObject

/**
 * Check if this position on the same route as passed.
 */
- (BOOL)onRouteWithRouteId:(nonnull NSString *)routeId;

/**
 * Return polyline position on route. If the position not on the passed
 * route none will be returned.
 */
- (nullable YMKPolylinePosition *)positionOnRouteWithRouteId:(nonnull NSString *)routeId;
/**
 * As point on the map
 */
@property (nonatomic, readonly, nonnull) YMKPoint *point;

/**
 * Create position shifted by distance. If the distance is more than
 * remains route length, the end of the route will be returned. If the
 * distance is less than a negative distance from the start, the
 * beginning of the route will be returned.
 */
- (nonnull YMKRoutePosition *)advanceWithDistance:(double)distance;

/**
 * Distance to another point on the route. Return none if point on
 * another route. May be less 0 if position "to" stay before this
 * position.
 */
- (nullable NSNumber *)distanceToWithTo:(nonnull YMKRoutePosition *)to;

/**
 * Determines if position precedes another position on the route. Throws
 * if another position belongs to another route.
 */
- (BOOL)precedesWithAnother:(nonnull YMKRoutePosition *)another;

/**
 * Determines if position precedes or equals another position on the
 * route. Throws if another position belongs to another route.
 */
- (BOOL)precedesOrEqualsWithAnother:(nonnull YMKRoutePosition *)another;

/**
 * Determines if position equals another position on the route. Throws
 * if another position belongs to another route.
 */
- (BOOL)equalsWithAnother:(nonnull YMKRoutePosition *)another;

/**
 * Heading movement on the route at this position. It is equal heading
 * of the segment which is belonged position.
 */
- (double)heading;

/**
 * Distance to the end of the route.
 */
- (double)distanceToFinish;

/**
 * Time to the end of the route.
 */
- (double)timeToFinish;

@end
