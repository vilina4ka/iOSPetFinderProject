#import <YandexMapsMobile/YMKCameraUpdateReason.h>

@class YMKCameraPosition;
@class YMKMap;

/**
 * Listens for updates to the camera position.
 */
@protocol YMKMapCameraListener <NSObject>

/**
 * Triggered when the camera position changed.
 *
 * @param map Event source.
 * @param cameraPosition Current camera position.
 * @param cameraUpdateReason The reason of camera update.
 * @param finished True if the camera finished moving, false otherwise.
 * If a movement is cancelled then cameraUpdateReason represents
 * initiator of cancellation.
 */
- (void)onCameraPositionChangedWithMap:(nonnull YMKMap *)map
                        cameraPosition:(nonnull YMKCameraPosition *)cameraPosition
                    cameraUpdateReason:(YMKCameraUpdateReason)cameraUpdateReason
                              finished:(BOOL)finished;

@end
