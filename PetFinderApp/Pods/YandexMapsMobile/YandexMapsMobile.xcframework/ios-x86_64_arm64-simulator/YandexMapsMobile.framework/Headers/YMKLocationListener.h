#import <YandexMapsMobile/YMKLocationStatus.h>

@class YMKLocation;

/**
 * The listener that handles the updates to the device location.
 */
@protocol YMKLocationDelegate <NSObject>

/**
 * Handle location update information,.
 */
- (void)onLocationUpdatedWithLocation:(nonnull YMKLocation *)location;

/**
 * Handle change in location provider status.
 */
- (void)onLocationStatusUpdatedWithStatus:(YMKLocationStatus)status;

@end
