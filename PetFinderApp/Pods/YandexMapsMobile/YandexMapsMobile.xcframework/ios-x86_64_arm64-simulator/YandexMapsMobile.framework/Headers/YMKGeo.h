#import <Foundation/Foundation.h>

@class YMKPoint;
@class YMKSegment;

/**
 * Undocumented
 */
@interface YMKGeo : NSObject

/**
 * Calculate the great-circle distance between two points on a sphere
 * with a radius equal to the Earth's radius using the haversine formula
 * described here: http://en.wikipedia.org/wiki/Haversine_formula
 *
 * This formula is numerically better-conditioned for small distances,
 * according to http://en.wikipedia.org/wiki/Great-circle_distance
 */
+ (double)distanceWithFirstPoint:(nonnull YMKPoint *)firstPoint
                     secondPoint:(nonnull YMKPoint *)secondPoint;

/**
 * Find the point on a given segment (great-circle arc or shorter arc)
 * that is closest to a given point.
 */
+ (nonnull YMKPoint *)closestPointWithPoint:(nonnull YMKPoint *)point
                                    segment:(nonnull YMKSegment *)segment;

/**
 * Find a point X on a given segment AB such that d(AX)/d(AB) = factor,
 * where factor is a given number in [0, 1].
 */
+ (nonnull YMKPoint *)pointOnSegmentByFactorWithSegment:(nonnull YMKSegment *)segment
                                                 factor:(double)factor;

/**
 * Calculate the course (bearing) between two points in degrees in the
 * range [0, 360].
 */
+ (double)courseWithFirstPoint:(nonnull YMKPoint *)firstPoint
                   secondPoint:(nonnull YMKPoint *)secondPoint;

@end
