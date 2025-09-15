#import <Foundation/Foundation.h>

/**
 * The way rotation is handled.
 */
typedef NS_ENUM(NSUInteger, YMKRotationType) {
    /**
     * Ignores the placemark direction; stable in screen space.
     */
    YMKRotationTypeNoRotation,
    /**
     * Follows the placemark direction. For non-flat placemarks, the
     * direction vector is projected onto the screen plane.
     */
    YMKRotationTypeRotate
};
