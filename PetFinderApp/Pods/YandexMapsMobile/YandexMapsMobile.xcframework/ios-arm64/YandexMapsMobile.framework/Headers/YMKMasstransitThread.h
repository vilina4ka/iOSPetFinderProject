#import <YandexMapsMobile/YMKMasstransitCommon.h>
#import <YandexMapsMobile/YMKPoint.h>

/**
 * Describes a YMKMasstransitStop on a YMKMasstransitThread.
 */
@interface YMKMasstransitThreadStop : NSObject

/**
 * Stop on a thread.
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitStop *stop;

/**
 * Coordinates of the thread stop.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *position;


+ (nonnull YMKMasstransitThreadStop *)threadStopWithStop:(nonnull YMKMasstransitStop *)stop
                                                position:(nonnull YMKPoint *)position;


@end
