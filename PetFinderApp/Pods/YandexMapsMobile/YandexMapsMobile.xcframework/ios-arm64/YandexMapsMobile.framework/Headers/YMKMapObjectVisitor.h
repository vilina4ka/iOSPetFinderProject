#import <Foundation/Foundation.h>

@class YMKCircleMapObject;
@class YMKClusterizedPlacemarkCollection;
@class YMKMapObjectCollection;
@class YMKPlacemarkMapObject;
@class YMKPolygonMapObject;
@class YMKPolylineMapObject;

/**
 * Used to traverse over the children of the MapObjectCollection.
 */
@protocol YMKMapObjectVisitor <NSObject>

/**
 * Called when a placemark is visited.
 */
- (void)onPlacemarkVisitedWithPlacemark:(nonnull YMKPlacemarkMapObject *)placemark;

/**
 * Called when a polyline is visited.
 */
- (void)onPolylineVisitedWithPolyline:(nonnull YMKPolylineMapObject *)polyline;

/**
 * Called when a polygon is visited.
 */
- (void)onPolygonVisitedWithPolygon:(nonnull YMKPolygonMapObject *)polygon;

/**
 * Called when a circle is visited.
 */
- (void)onCircleVisitedWithCircle:(nonnull YMKCircleMapObject *)circle;

/**
 * Called for every child collection. The collection is ignored if this
 * method returns false.
 */
- (BOOL)onCollectionVisitStartWithCollection:(nonnull YMKMapObjectCollection *)collection;

/**
 * Called for visited collections only. If an exception occurred during
 * the visit, the method might be skipped.
 */
- (void)onCollectionVisitEndWithCollection:(nonnull YMKMapObjectCollection *)collection;

/**
 * Called for clusterized placemark collection. The collection is
 * ignored if this method returns false.
 */
- (BOOL)onClusterizedCollectionVisitStartWithCollection:(nonnull YMKClusterizedPlacemarkCollection *)collection;

/**
 * Called for visited clusterized placemark collections only. If an
 * exception occurred during the visit, the method might be skipped.
 */
- (void)onClusterizedCollectionVisitEndWithCollection:(nonnull YMKClusterizedPlacemarkCollection *)collection;

@end
