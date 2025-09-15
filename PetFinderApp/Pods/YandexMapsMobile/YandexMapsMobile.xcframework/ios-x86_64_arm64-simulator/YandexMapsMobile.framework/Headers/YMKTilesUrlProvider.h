#import <YandexMapsMobile/YMKTileId.h>
#import <YandexMapsMobile/YMKVersion.h>

/**
 * Provides a formatted URL.
 */
@protocol YMKTilesUrlProvider <NSObject>

/**
 * Create s a URL based on the tile ID, version, and features. Features
 * are some layer customisations. Tiles with appropriate features are
 * prioretized over tiles without them when loading.
 *
 * This method may be called on any thread. Its implementation must be thread-safe.
 */
- (nonnull NSString *)formatUrlWithTileId:(nonnull YMKTileId *)tileId
                                  version:(nonnull YMKVersion *)version
                                 features:(nonnull NSDictionary<NSString *, NSString *> *)features;

@end
