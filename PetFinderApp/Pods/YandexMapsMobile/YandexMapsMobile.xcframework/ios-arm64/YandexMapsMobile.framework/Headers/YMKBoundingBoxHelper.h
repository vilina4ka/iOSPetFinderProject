#import <Foundation/Foundation.h>

@class YMKBoundingBox;
@class YMKLinearRing;
@class YMKPoint;
@class YMKPolygon;
@class YMKPolyline;

/**
 * Undocumented
 */
@interface YMKBoundingBoxHelper : NSObject

/**
 * Gets bounds based on a bounding box.
 */
+ (nonnull YMKBoundingBox *)getBoundsWithBbox:(nonnull YMKBoundingBox *)bbox;

/**
 * Gets bounds based on a point.
 */
+ (nonnull YMKBoundingBox *)getBoundsWithPoint:(nonnull YMKPoint *)point;

/**
 * Gets bounds based on a polyline.
 */
+ (nonnull YMKBoundingBox *)getBoundsWithPolyline:(nonnull YMKPolyline *)polyline;

/**
 * Gets bounds based on a linear ring.
 */
+ (nonnull YMKBoundingBox *)getBoundsWithRing:(nonnull YMKLinearRing *)ring;

/**
 * Gets bounds based on a polygon.
 */
+ (nonnull YMKBoundingBox *)getBoundsWithPolygon:(nonnull YMKPolygon *)polygon;

/**
 * Gets bounds based on two bounding boxes.
 */
+ (nonnull YMKBoundingBox *)getBoundsWithFirst:(nonnull YMKBoundingBox *)first
                                        second:(nonnull YMKBoundingBox *)second;

@end
