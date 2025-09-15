#import <Foundation/Foundation.h>

/**
 * The reason of the camera update.
 */
typedef NS_ENUM(NSUInteger, YMKCameraUpdateReason) {
    /**
     * User manipulation, for example: zoom, scroll, rotate, fling.
     */
    YMKCameraUpdateReasonGestures,
    /**
     * Application, by calling the map::move method.
     */
    YMKCameraUpdateReasonApplication
};
