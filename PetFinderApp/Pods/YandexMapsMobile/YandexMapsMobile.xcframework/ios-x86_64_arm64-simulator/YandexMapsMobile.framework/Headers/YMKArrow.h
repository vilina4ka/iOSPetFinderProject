#import <YandexMapsMobile/YMKGeometry.h>

#import <UIKit/UIKit.h>

/**
 * The arrow element.
 */
@interface YMKArrow : NSObject
/**
 * Arrow center.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;
/**
 * Arrow fill color.
 */
@property (nonatomic, nonnull) UIColor *fillColor;
/**
 * Color of the arrow's outline. Default: white.
 */
@property (nonatomic, nonnull) UIColor *outlineColor;
/**
 * The width of the outline in units. Default: 2.
 */
@property (nonatomic) float outlineWidth;
/**
 * The overall length of the arrow (including the tip) in units. The
 * size of a unit is equal to the size of a pixel at the current zoom
 * level when the camera tilt is equal to 0 and the scale factor is
 * equal to 1.
 */
@property (nonatomic) float length;
/**
 * Arrow visibility. Default: true.
 */
@property (nonatomic, getter=isVisible) BOOL visible;
/**
 * Describes height of the arrowhead in units. Default: 0.2 * length.
 */
@property (nonatomic) float triangleHeight;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
