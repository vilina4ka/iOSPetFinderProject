#import <Foundation/Foundation.h>

@class YMKBaseDataSource;

/**
 * Undocumented
 */
@protocol YMKDataSourceListener <NSObject>

/**
 * Undocumented
 */
- (void)onDataSourceUpdatedWithDataSource:(nonnull YMKBaseDataSource *)dataSource;

@end

/**
 * Undocumented
 */
@interface YMKBaseDataSource : NSObject
/**
 * Stores id of data source.
 */
@property (nonatomic, readonly, nonnull) NSString *id;

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
 * Undocumented
 */
@interface YMKTileDataSource : YMKBaseDataSource

/**
 * Invalidates data source and reloads all tiles. Must not be called if
 * DataSource does not support versioning: LayerOptions.versionSupport =
 * false;
 *
 * This method may be called on any thread. Its implementation must be thread-safe.
 */
- (void)invalidateWithVersion:(nonnull NSString *)version;

@end

/**
 * Undocumented
 */
@interface YMKDataSource : YMKBaseDataSource

/**
 * Updates all data. This method works synchronously and blocks UI
 * thread. It is intended for passing not more than 500kB of data;
 * otherwise, it will affect the responsiveness of UI and map.
 */
- (void)setDataWithData:(nonnull NSData *)data;

@end
