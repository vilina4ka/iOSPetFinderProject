#import <YandexMapsMobile/YMKRawTile.h>
#import <YandexMapsMobile/YMKTileId.h>
#import <YandexMapsMobile/YMKVersion.h>

/**
 * Generates tiles.
 */
@protocol YMKTileProvider <NSObject>

/**
 * Generates tile.
 *
 * This method will be called on a background thread.
 */
- (nonnull YMKRawTile *)loadWithTileId:(nonnull YMKTileId *)tileId
                               version:(nonnull YMKVersion *)version
                              features:(nonnull NSDictionary<NSString *, NSString *> *)features
                                  etag:(nonnull NSString *)etag;

@end
