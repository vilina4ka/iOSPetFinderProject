#import <Foundation/Foundation.h>

/**
 * Represents the panorama direction.
 */
@interface YMKDirection : NSObject

/**
 * Panorama azimuth.
 */
@property (nonatomic, readonly) double azimuth;

/**
 * Panorama tilt.
 */
@property (nonatomic, readonly) double tilt;


+ (nonnull YMKDirection *)directionWithAzimuth:( double)azimuth
                                          tilt:( double)tilt;


@end
