#import <YandexMapsMobile/YMKVersion.h>

/**
 * Available tile states.
 */
typedef NS_ENUM(NSUInteger, YMKRawTileState) {
    /**
     * Tile is available.
     */
    YMKRawTileStateOk,
    /**
     * Tile was not modified.
     */
    YMKRawTileStateNotModified,
    /**
     * An error occurred when processing the tile.
     */
    YMKRawTileStateError
};

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKRawTileUseCache) {
    /**
     * Undocumented
     */
    YMKRawTileUseCacheYes,
    /**
     * Undocumented
     */
    YMKRawTileUseCacheNo
};

/**
 * A raw tile that can be displayed on the map.
 */
@interface YMKRawTile : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKVersion *version;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, NSString *> *features;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSString *etag;

/**
 * Undocumented
 */
@property (nonatomic, readonly) YMKRawTileUseCache useCache;

/**
 * Undocumented
 */
@property (nonatomic, readonly) YMKRawTileState state;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSData *rawData;


+ (nonnull YMKRawTile *)rawTileWithVersion:(nonnull YMKVersion *)version
                                  features:(nonnull NSDictionary<NSString *, NSString *> *)features
                                      etag:(nonnull NSString *)etag
                                  useCache:( YMKRawTileUseCache)useCache
                                     state:( YMKRawTileState)state
                                   rawData:(nonnull NSData *)rawData;


@end
