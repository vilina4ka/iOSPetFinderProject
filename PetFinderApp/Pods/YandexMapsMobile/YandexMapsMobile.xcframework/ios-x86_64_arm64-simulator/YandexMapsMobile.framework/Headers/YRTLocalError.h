#import <YandexMapsMobile/YRTError.h>

/**
 * Local error has occurred.
 */
@interface YRTLocalError : YRTError

@end

/**
 * Disk is full.
 */
@interface YRTDiskFullError : YRTLocalError

@end

/**
 * Disk is corrupted.
 */
@interface YRTDiskCorruptError : YRTLocalError

@end

/**
 * The application does not have the required write permissions.
 */
@interface YRTDiskWriteAccessError : YRTDiskCorruptError

@end
