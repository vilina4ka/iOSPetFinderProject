#import <YandexMapsMobile/YMKPoint.h>

/**
 * A rectangular box around the object.
 */
@interface YMKBoundingBox : NSObject

/**
 * The coordinates of the southwest corner of the box.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *southWest;

/**
 * The coordinates of the northeast corner of the box.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *northEast;


+ (nonnull YMKBoundingBox *)boundingBoxWithSouthWest:(nonnull YMKPoint *)southWest
                                           northEast:(nonnull YMKPoint *)northEast;


@end

/**
 * A circle around the specified point.
 */
@interface YMKCircle : NSObject

/**
 * The coordinates of the center of the circle.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *center;

/**
 * The radius of the circle in meters.
 */
@property (nonatomic, readonly) float radius;


+ (nonnull YMKCircle *)circleWithCenter:(nonnull YMKPoint *)center
                                 radius:( float)radius;


@end

/**
 * A line between two points.
 */
@interface YMKSegment : NSObject

/**
 * Starting point of the segment.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *startPoint;

/**
 * End point of the segment.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *endPoint;


+ (nonnull YMKSegment *)segmentWithStartPoint:(nonnull YMKPoint *)startPoint
                                     endPoint:(nonnull YMKPoint *)endPoint;


@end

/**
 * A polyline between a number of points. A polyline is drawn between
 * consecutive points.
 */
@interface YMKPolyline : NSObject

/**
 * The list of points to connect.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPoint *> *points;


+ (nonnull YMKPolyline *)polylineWithPoints:(nonnull NSArray<YMKPoint *> *)points;


@end

/**
 * The position on a polyline.
 */
@interface YMKPolylinePosition : NSObject

/**
 * Zero-based index of the polyline segment.
 */
@property (nonatomic, readonly) NSUInteger segmentIndex;

/**
 * Position in the specified segment. Possible values: from 0 to 1,
 * where 0 is the start of the segment and 1 is the end of it.
 */
@property (nonatomic, readonly) double segmentPosition;


+ (nonnull YMKPolylinePosition *)polylinePositionWithSegmentIndex:( NSUInteger)segmentIndex
                                                  segmentPosition:( double)segmentPosition;


@end

/**
 * A part of a polyline.
 */
@interface YMKSubpolyline : NSObject

/**
 * The start of the selected part of the polyline.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *begin;

/**
 * The end of the selected part of the polyline.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *end;


+ (nonnull YMKSubpolyline *)subpolylineWithBegin:(nonnull YMKPolylinePosition *)begin
                                             end:(nonnull YMKPolylinePosition *)end;


@end

/**
 * A sequence of four or more vertices, with all points along the
 * linearly-interpolated curves (line segments) between each pair of
 * consecutive vertices. A ring must have either 0, 4 or more points.
 * The first and last points of the ring must be in the same position.
 * The ring must not intersect with itself.
 */
@interface YMKLinearRing : NSObject

/**
 * The list of points to connect.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPoint *> *points;


+ (nonnull YMKLinearRing *)linearRingWithPoints:(nonnull NSArray<YMKPoint *> *)points;


@end

/**
 * A polygon with one or more polygons in it. The exterior and interior
 * areas are specified using LinearRing.
 */
@interface YMKPolygon : NSObject

/**
 * The ring specifying the area.
 */
@property (nonatomic, readonly, nonnull) YMKLinearRing *outerRing;

/**
 * The list of rings in the specified area.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKLinearRing *> *innerRings;


+ (nonnull YMKPolygon *)polygonWithOuterRing:(nonnull YMKLinearRing *)outerRing
                                  innerRings:(nonnull NSArray<YMKLinearRing *> *)innerRings;


@end

/**
 * An area consisting of multiple external polygons.
 */
@interface YMKMultiPolygon : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPolygon *> *polygons;


+ (nonnull YMKMultiPolygon *)multiPolygonWithPolygons:(nonnull NSArray<YMKPolygon *> *)polygons;


@end

/**
 * A container of other geometry objects. Point - A point on the map.
 * Polyline - A polyline between a number of points. Polygon - A polygon
 * with one or more polygons in it. BoundingBox - A rectangular box
 * around the object. Circle - A circle around the specified point.
 */
@interface YMKGeometry : NSObject

@property (nonatomic, readonly, nullable) YMKPoint *point;

@property (nonatomic, readonly, nullable) YMKPolyline *polyline;

@property (nonatomic, readonly, nullable) YMKPolygon *polygon;

@property (nonatomic, readonly, nullable) YMKMultiPolygon *multiPolygon;

@property (nonatomic, readonly, nullable) YMKBoundingBox *boundingBox;

@property (nonatomic, readonly, nullable) YMKCircle *circle;

+ (nonnull YMKGeometry *)geometryWithPoint:(nonnull YMKPoint *)point;

+ (nonnull YMKGeometry *)geometryWithPolyline:(nonnull YMKPolyline *)polyline;

+ (nonnull YMKGeometry *)geometryWithPolygon:(nonnull YMKPolygon *)polygon;

+ (nonnull YMKGeometry *)geometryWithMultiPolygon:(nonnull YMKMultiPolygon *)multiPolygon;

+ (nonnull YMKGeometry *)geometryWithBoundingBox:(nonnull YMKBoundingBox *)boundingBox;

+ (nonnull YMKGeometry *)geometryWithCircle:(nonnull YMKCircle *)circle;

@end

