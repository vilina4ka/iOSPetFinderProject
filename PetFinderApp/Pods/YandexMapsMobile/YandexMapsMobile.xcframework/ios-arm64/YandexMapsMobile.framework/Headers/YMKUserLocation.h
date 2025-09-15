#import <YandexMapsMobile/YMKCameraPosition.h>
#import <YandexMapsMobile/YMKCircle.h>
#import <YandexMapsMobile/YMKLocationViewSource.h>
#import <YandexMapsMobile/YMKObjectEvent.h>
#import <YandexMapsMobile/YMKPlacemark.h>
#import <YandexMapsMobile/YMKPoint.h>

#import <UIKit/UIKit.h>

@class YMKUserLocationView;

/**
 * The type of icon to use.
 */
typedef NS_ENUM(NSUInteger, YMKUserLocationIconType) {
    /**
     * Arrow icon.
     */
    YMKUserLocationIconTypeArrow,
    /**
     * Pin icon.
     */
    YMKUserLocationIconTypePin
};

/**
 * The type of anchor to use.
 */
typedef NS_ENUM(NSUInteger, YMKUserLocationAnchorType) {
    /**
     * Normal anchor.
     */
    YMKUserLocationAnchorTypeNormal,
    /**
     * Course anchor.
     */
    YMKUserLocationAnchorTypeCourse
};

/**
 * User location events object listener. Use it to customize the user
 * location view. Although some callbacks are unused, the generic
 * structure of the interface is suitable for object layer listeners.
 */
@protocol YMKUserLocationObjectListener <NSObject>

/**
 * Called when the layer object is added. It is called once when the
 * user location icon appears the first time.
 */
- (void)onObjectAddedWithView:(nonnull YMKUserLocationView *)view;

/**
 * Called when the layer object is being removed. It is never called for
 * the user location icon.
 */
- (void)onObjectRemovedWithView:(nonnull YMKUserLocationView *)view;

/**
 * Called when the layer object is being updated. The 'event' parameter
 * can be one of the derived types.
 */
- (void)onObjectUpdatedWithView:(nonnull YMKUserLocationView *)view
                          event:(nonnull YMKObjectEvent *)event;

@end

/**
 * Triggered by a tap on the user location icon.
 */
@protocol YMKUserLocationTapListener <NSObject>

/**
 * Called when the user taps a location object.
 */
- (void)onUserLocationObjectTapWithPoint:(nonnull YMKPoint *)point;

@end

/**
 * Use this interface to specify the appearance of the user location
 * icon elements.
 */
@interface YMKUserLocationView : NSObject
/**
 * Gets the location arrow map object.
 */
@property (nonatomic, readonly, readonly, nonnull) YMKPlacemarkMapObject *arrow;
/**
 * Gets the location pin map object.
 */
@property (nonatomic, readonly, readonly, nonnull) YMKPlacemarkMapObject *pin;
/**
 * Gets the GPS accuracy circle map object.
 */
@property (nonatomic, readonly, readonly, nonnull) YMKCircleMapObject *accuracyCircle;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end

/**
 * This event triggers when the user location icon type is changed.
 */
@interface YMKUserLocationIconChanged : YMKObjectEvent
/**
 * Gets the type of user location icon used.
 */
@property (nonatomic, readonly) YMKUserLocationIconType iconType;

@end

/**
 * Event for a change in the user location icon anchor.
 */
@interface YMKUserLocationAnchorChanged : YMKObjectEvent
/**
 * Gets the type of anchor used.
 */
@property (nonatomic, readonly) YMKUserLocationAnchorType anchorType;

@end

/**
 * Use the UserLocationLayer interface to manage the location icon: its
 * appearance, following mode, data source and so on.
 */
@interface YMKUserLocationLayer : NSObject

/**
 * Sets user location visibility.
 */
- (void)setVisibleWithOn:(BOOL)on;

/**
 * Checks if user location is visible.
 */
- (BOOL)isVisible;
/**
 * Enables/disables heading mode. If heading mode is enabled, the map is
 * rotated. If heading mode is disabled, the location icon is rotated.
 */
@property (nonatomic, getter=isHeadingModeActive) BOOL headingModeActive;

/**
 * Sets the anchor to the specified position in pixels and enables
 * Anchor mode. (0, 0) denotes the top-left corner of the screen.
 *
 * @param anchorNormal The anchor position when the app is not on a
 * steady course; usually, the center of the screen.
 * @param anchorCourse An anchor position near the bottom line for
 * steady course mode.
 */
- (void)setAnchorWithAnchorNormal:(CGPoint)anchorNormal
                     anchorCourse:(CGPoint)anchorCourse;

/**
 * Resets anchor mode.
 */
- (void)resetAnchor;
/**
 * Returns true if anchor mode is set, and false otherwise.
 */
@property (nonatomic, readonly, getter=isAnchorEnabled) BOOL anchorEnabled;
/**
 * Enables/disables auto zoom.
 */
@property (nonatomic, getter=isAutoZoomEnabled) BOOL autoZoomEnabled;

/**
 * Calculates the camera position that projects the current location
 * into view. If the current location is unknown, returns none. If the
 * current location is known, returns the camera position that displays
 * the location position.
 */
- (nullable YMKCameraPosition *)cameraPosition;

/**
 * Sets/gets the data source.
 */
- (void)setSourceWithSource:(nullable YMKLocationViewSource *)source;

/**
 * Sets the data source with the global location manager
 */
- (void)setDefaultSource;

/**
 * Sets/resets the tap listener.
 *
 * The class does not retain the object in the 'tapListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)setTapListenerWithTapListener:(nullable id<YMKUserLocationTapListener>)tapListener;

/**
 * Sets/resets the object listener.
 *
 * The class does not retain the object in the 'objectListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)setObjectListenerWithObjectListener:(nullable id<YMKUserLocationObjectListener>)objectListener;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
