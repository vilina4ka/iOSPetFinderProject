#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YMKMapObject.h>

#import <UIKit/UIKit.h>

/**
 * The circle element.
 */
@interface YMKCircleMapObject : YMKMapObject
/**
 * Undocumented
 */
@property (nonatomic, nonnull) YMKCircle *geometry;
/**
 * Sets the stroke color. Setting the stroke color to any transparent
 * color (for example, RGBA code 0x00000000) effectively disables the
 * stroke. default: 0x0066FFFF
 */
@property (nonatomic, nonnull) UIColor *strokeColor;
/**
 * Sets the stroke width in units. The size of a unit is equal to the
 * size of a pixel at the current zoom level when the camera position's
 * tilt is equal to 0 and the scale factor is equal to 1. default: 5
 */
@property (nonatomic) float strokeWidth;
/**
 * Sets the fill color. default: 0x0066FF99
 */
@property (nonatomic, nonnull) UIColor *fillColor;
/**
 * The object's geometry can be interpreted in two different ways:
 * <ul><li>If the object mode is 'geodesic', the object's geometry is
 * defined on a sphere.</li> <li>Otherwise, the object's geometry is
 * defined in projected space.</li></ul> Default: false.
 */
@property (nonatomic, getter=isGeodesic) BOOL geodesic;

@end
