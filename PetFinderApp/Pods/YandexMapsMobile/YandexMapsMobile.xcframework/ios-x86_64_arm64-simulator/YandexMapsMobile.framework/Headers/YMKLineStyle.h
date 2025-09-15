#import <UIKit/UIKit.h>

/**
 * The style of the polyline.
 */
@interface YMKLineStyle : NSObject

/**
 * The stroke width in units. Default: 5. The size of a unit is equal to
 * the size of a pixel at the current zoom level when the camera
 * position's tilt is equal to 0 and the scale factor is equal to 1.
 */
@property (nonatomic, assign) float strokeWidth;

/**
 * Maximum length (in units) of the gradient from one color to another.
 * Default: 0.
 */
@property (nonatomic, assign) float gradientLength;

/**
 * The outline color. Default: hexademical RGBA code 0x00000000.
 */
@property (nonatomic, strong, nonnull) UIColor *outlineColor;

/**
 * Width of the outline in units. Default: 0.
 */
@property (nonatomic, assign) float outlineWidth;

/**
 * Enables the inner outline if true (a dark border along the edge of
 * the outline). Default: false.
 */
@property (nonatomic, assign) BOOL innerOutlineEnabled;

/**
 * Maximum radius of a turn. Measured in units. Default: 10.
 */
@property (nonatomic, assign) float turnRadius;

/**
 * Defines step of arc approximation. Smaller values make polyline
 * smoother. Measured in degrees. Default: 12.
 */
@property (nonatomic, assign) float arcApproximationStep;

/**
 * Length of a dash in units. Default: 0 (dashing is turned off). Arrows
 * are ignored in dashed polylines.
 */
@property (nonatomic, assign) float dashLength;

/**
 * Length of the gap between two dashes in units. Default: 0 (dashing is
 * turned off). Arrows are ignored in dashed polylines.
 */
@property (nonatomic, assign) float gapLength;

/**
 * Offset from the start of the polyline to the reference dash in units.
 * Default: 0.
 */
@property (nonatomic, assign) float dashOffset;

+ (nonnull YMKLineStyle *)lineStyleWithStrokeWidth:( float)strokeWidth
                                    gradientLength:( float)gradientLength
                                      outlineColor:(nonnull UIColor *)outlineColor
                                      outlineWidth:( float)outlineWidth
                               innerOutlineEnabled:( BOOL)innerOutlineEnabled
                                        turnRadius:( float)turnRadius
                              arcApproximationStep:( float)arcApproximationStep
                                        dashLength:( float)dashLength
                                         gapLength:( float)gapLength
                                        dashOffset:( float)dashOffset;


- (nonnull YMKLineStyle *)init;

@end
