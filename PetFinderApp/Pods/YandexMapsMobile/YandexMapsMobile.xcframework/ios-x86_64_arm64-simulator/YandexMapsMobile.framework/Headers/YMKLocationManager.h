#import <YandexMapsMobile/YMKLocationListener.h>
#import <YandexMapsMobile/YMKPurpose.h>

@class YMKLocation;
@class YMKLocationSubscriptionSettings;

/**
 * If UseInBackground is Allow then the 'location' flag must be set in
 * 'UIBackgroundModes' of the application.
 */
typedef NS_ENUM(NSUInteger, YMKLocationUseInBackground) {
    /**
     * Undocumented
     */
    YMKLocationUseInBackgroundAllow,
    /**
     * Undocumented
     */
    YMKLocationUseInBackgroundDisallow
};

/**
 * Undocumented
 */
@interface YMKLocationSubscriptionSettings : NSObject

/**
 * If UseInBackground is Allow then the 'location' flag must be set in
 * 'UIBackgroundModes' of the application.
 */
@property (nonatomic, readonly) YMKLocationUseInBackground useInBackground;

/**
 * Defines for what purpose the locations from the subscription will be
 * used. Depending on the purpose, it tries to optimize requests for
 * locations.
 */
@property (nonatomic, readonly) YMKPurpose purpose;


+ (nonnull YMKLocationSubscriptionSettings *)subscriptionSettingsWithUseInBackground:( YMKLocationUseInBackground)useInBackground
                                                                             purpose:( YMKPurpose)purpose;


@end

/**
 * Handles location updates and changes.
 */
@interface YMKLocationManager : NSObject

/**
 * Subscribe for location update events. If the listener was already
 * subscribed to updates from the LocationManager, subscription settings
 * will be updated.
 *
 * The class does not retain the object in the 'locationListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 *
 * @param subscriptionSettings Subscription settings.
 * @param locationListener Location update listener.
 */
- (void)subscribeForLocationUpdatesWithSubscriptionSettings:(nonnull YMKLocationSubscriptionSettings *)subscriptionSettings
                                           locationListener:(nonnull id<YMKLocationDelegate>)locationListener;

/**
 * Subscribe to a single location update. If the listener was already
 * subscribed to location updates, the previous subscription will be
 * removed.
 *
 * The class does not retain the object in the 'locationListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 *
 * @param locationListener Location update listener.
 */
- (void)requestSingleUpdateWithLocationListener:(nonnull id<YMKLocationDelegate>)locationListener;

/**
 * Unsubscribe from location update events. Can be called for either
 * YMKLocationManager::subscribeForLocationUpdatesWithSubscriptionSettings:locationListener:
 * or YMKLocationManager::requestSingleUpdateWithLocationListener:. For
 * YMKLocationManager::requestSingleUpdateWithLocationListener:, if an
 * event was already received,
 * YMKLocationManager::unsubscribeWithLocationListener: does not have
 * any effect. If the listener is already unsubscribed, the method call
 * is ignored.
 *
 * The class does not retain the object in the 'locationListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 *
 * @param locationListener Listener passed to either
 * YMKLocationManager::subscribeForLocationUpdatesWithSubscriptionSettings:locationListener:
 * or YMKLocationManager::requestSingleUpdateWithLocationListener:.
 */
- (void)unsubscribeWithLocationListener:(nonnull id<YMKLocationDelegate>)locationListener;

/**
 * Stops updates for all subscriptions until resume() is called.
 */
- (void)suspend;

/**
 * Resumes updates stopped by a suspend() call.
 */
- (void)resume;

@end

/**
 * Undocumented
 */
@interface YMKLocationManagerUtils : NSObject

+ (nullable YMKLocation *)lastKnownLocation;

@end
