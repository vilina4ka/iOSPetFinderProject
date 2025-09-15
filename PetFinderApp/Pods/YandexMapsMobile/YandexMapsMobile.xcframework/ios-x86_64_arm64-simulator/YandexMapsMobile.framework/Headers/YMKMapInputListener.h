#import <YandexMapsMobile/YMKPoint.h>

@class YMKMap;

/**
 * Listener for user interactions with the map.
 */
@protocol YMKMapInputListener <NSObject>

/**
 * Called when a tap occurred unless a tap was handled by geo objects or
 * map objects. param@ position absolute screen coordinates
 */
- (void)onMapTapWithMap:(nonnull YMKMap *)map
                  point:(nonnull YMKPoint *)point;

/**
 * Called when a long tap occurred.
 */
- (void)onMapLongTapWithMap:(nonnull YMKMap *)map
                      point:(nonnull YMKPoint *)point;

@end
