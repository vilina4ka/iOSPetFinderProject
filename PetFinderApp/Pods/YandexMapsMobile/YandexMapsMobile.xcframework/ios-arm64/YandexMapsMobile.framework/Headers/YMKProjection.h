#import <YandexMapsMobile/YMKPoint.h>

@class YMKXYPoint;

/**
 * Makes two conversions: world->XY and XY->world, where XY are tile
 * indexes. There are two main derived classes: spherical mercator
 * (google, osm) and wgs84 mercator (yandex).
 */
@interface YMKProjection : NSObject

/**
 * Converts the world coordinates to a flat world position.
 */
- (nonnull YMKXYPoint *)worldToXYWithGeoPoint:(nonnull YMKPoint *)geoPoint
                                         zoom:(NSInteger)zoom;

/**
 * Converts the flat world position to world coordinates.
 */
- (nonnull YMKPoint *)xyToWorldWithXyPoint:(nonnull YMKXYPoint *)xyPoint
                                      zoom:(NSInteger)zoom;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
