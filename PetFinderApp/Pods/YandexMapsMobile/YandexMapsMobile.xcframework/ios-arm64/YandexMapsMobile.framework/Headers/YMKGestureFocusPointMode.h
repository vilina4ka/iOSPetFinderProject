#import <Foundation/Foundation.h>

/**
 * Specifies the way provided zoom focus point affects gestures.
 */
typedef NS_ENUM(NSUInteger, YMKGestureFocusPointMode) {
    /**
     * Only "double tap" (zoom in) and "tap with two fingers" (zoom out) use
     * provided gesture focus point. Other gestures ignore it and continue
     * to use their source point for transformation.
     */
    YMKGestureFocusPointModeAffectsTapGestures,
    /**
     * All gestures: pinch and stretch, tap and swipe, double tap, tap with
     * two fingers, rotation use provided gesture focus point and ignore
     * their source point. @attention Scroll is suppressed when this mode is
     * on and "pinch and stretch" or "rotation" gesture performed
     */
    YMKGestureFocusPointModeAffectsAllGestures
};
