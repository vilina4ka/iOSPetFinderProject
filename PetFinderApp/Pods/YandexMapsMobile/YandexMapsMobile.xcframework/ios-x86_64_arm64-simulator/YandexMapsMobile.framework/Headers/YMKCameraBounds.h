#import <YandexMapsMobile/YMKGeometry.h>

/**
 * The object that is used to interact with the map bounds.
 */
@interface YMKCameraBounds : NSObject

/**
 * Minimum available zoom level considering zoom level hint provided via
 * #setMinZoomPreference.
 */
- (float)getMinZoom;

/**
 * Maximum available zoom level considering zoom level hint provided via
 * #setMaxZoomPreference
 */
- (float)getMaxZoom;

/**
 * Set minimum available zoom level hint.
 */
- (void)setMinZoomPreferenceWithZoom:(float)zoom;

/**
 * Set maximum available zoom level hint.
 */
- (void)setMaxZoomPreferenceWithZoom:(float)zoom;

/**
 * Reset minimum and maximum available zoom level hints.
 */
- (void)resetMinMaxZoomPreference;
/**
 * Latitudes should be in range [-89.3, 89.3]. Longitudes should be in
 * range [-180, 180).
 *
 * Optional property, can be nil.
 */
@property (nonatomic, nullable) YMKBoundingBox *latLngBounds;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
