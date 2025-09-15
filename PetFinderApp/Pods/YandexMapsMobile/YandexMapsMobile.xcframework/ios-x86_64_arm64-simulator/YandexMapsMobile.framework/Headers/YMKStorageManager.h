#import <YandexMapsMobile/YMKStorageErrorListener.h>

/**
 * Undocumented
 */
typedef void(^YMKStorageManagerClearCallback)(
    void);

/**
 * Undocumented
 */
typedef void(^YMKStorageManagerSizeCallback)(
    NSNumber * _Nullable bytes,
    NSError * _Nullable error);

/**
 * Storage manager. This is a manager that controls temporary cache
 * storages (for example map tiles).
 */
@interface YMKStorageManager : NSObject

/**
 * Subscribes to storage events.
 *
 * The class does not retain the object in the 'errorListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)addStorageErrorListenerWithErrorListener:(nonnull id<YMKStorageErrorListener>)errorListener;

/**
 * Unsubscribes from storage events.
 */
- (void)removeStorageErrorListenerWithErrorListener:(nonnull id<YMKStorageErrorListener>)errorListener;

/**
 * Computes storage size in bytes.
 */
- (void)computeSizeWithSizeCallback:(nonnull YMKStorageManagerSizeCallback)sizeCallback;

/**
 * Removes all data.
 */
- (void)clearWithClearCallback:(nonnull YMKStorageManagerClearCallback)clearCallback;

/**
 * Sets the maximum tile cache size to limit bytes. When the limit is
 * reached, old tiles are removed.
 */
- (void)setMaxTileStorageSizeWithLimit:(long long)limit
                          sizeCallback:(nonnull YMKStorageManagerSizeCallback)sizeCallback;

/**
 * Resets the tile cache size limit.
 */
- (void)resetMaxTileStorageSizeWithSizeCallback:(nonnull YMKStorageManagerSizeCallback)sizeCallback;

/**
 * Obtains the current storage size limit in bytes.
 */
- (void)maxTileStorageSizeWithSizeCallback:(nonnull YMKStorageManagerSizeCallback)sizeCallback;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
