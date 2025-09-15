#import <YandexMapsMobile/YMKPoint.h>

/**
 * The position of the camera.
 */
@interface YMKCameraPosition : NSObject

/**
 * The point the camera is looking at.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *target;

/**
 * Zoom level. 0 corresponds to the whole world displayed in a single
 * tile.
 */
@property (nonatomic, readonly) float zoom;

/**
 * Angle between north and the direction of interest on the map plane,
 * in degrees in the range [0, 360).
 */
@property (nonatomic, readonly) float azimuth;

/**
 * Camera tilt in degrees. 0 means vertical downward.
 */
@property (nonatomic, readonly) float tilt;


+ (nonnull YMKCameraPosition *)cameraPositionWithTarget:(nonnull YMKPoint *)target
                                                   zoom:( float)zoom
                                                azimuth:( float)azimuth
                                                   tilt:( float)tilt;


@end
