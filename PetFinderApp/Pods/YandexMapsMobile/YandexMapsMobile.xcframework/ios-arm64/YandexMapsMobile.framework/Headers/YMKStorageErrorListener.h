#import <YandexMapsMobile/YRTLocalError.h>

/**
 * Storage error listener. This is a listener to subscribe to storage
 * errors in managers that control some type of storage.
 */
@protocol YMKStorageErrorListener <NSObject>

/**
 * Possible error types: - YRTDiskCorruptError: Called if local storage
 * is corrupted. - YRTDiskFullError: Called if local storage is full. -
 * YRTDiskWriteAccessError: Called if the application cannot get write
 * access to local storage.
 */
- (void)onStorageErrorWithError:(nonnull YRTLocalError *)error;

@end
