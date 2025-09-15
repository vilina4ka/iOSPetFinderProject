#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YMKMapObject.h>
#import <YandexMapsMobile/YRTAnimatedImageProvider.h>

#import <UIKit/UIKit.h>

/**
 * A polygon displayed on the map.
 */
@interface YMKPolygonMapObject : YMKMapObject
/**
 * Undocumented
 */
@property (nonatomic, nonnull) YMKPolygon *geometry;
/**
 * Sets the stroke color. Default: hexademical RGBA code 0x0066FFFF.
 * Setting the stroke color to any transparent color (for example, RGBA
 * code 0x00000000) effectively disables the stroke.
 */
@property (nonatomic, nonnull) UIColor *strokeColor;
/**
 * Sets the stroke width in units. Default: 5. The size of a unit is
 * equal to the size of a pixel at the current zoom when the camera
 * position's tilt is equal to 0 and the scale factor is equal to 1.
 */
@property (nonatomic) float strokeWidth;
/**
 * Sets the fill color. Default: hexademical RGBA code 0x0066FF99.
 * @attention Fill color is ignored if a pattern is set.
 */
@property (nonatomic, nonnull) UIColor *fillColor;
/**
 * The object geometry can be interpreted in two different ways:
 * <ul><li>If the object mode is 'geodesic', the object geometry is
 * defined on a sphere.</li> <li>Otherwise, the object geometry is
 * defined in projected space.</li></ul> Default: false.
 */
@property (nonatomic, getter=isGeodesic) BOOL geodesic;

/**
 * Sets pattern to fill polygon. @attention Original linear sizes of
 * pattern should be equal to power of 2. @attention Fill color is
 * ignored if a pattern is set.
 */
- (void)setPatternWithAnimatedImage:(nonnull id<YRTAnimatedImageProvider>)animatedImage
                              scale:(float)scale;

/**
 * Sets pattern to fill polygon. @attention Original linear sizes of
 * pattern should be equal to power of 2. @attention Fill color is
 * ignored if pattern is set.
 */
- (void)setPatternWithImage:(nonnull UIImage *)image
                      scale:(float)scale;

/**
 * Removes pattern.
 */
- (void)resetPattern;

@end
