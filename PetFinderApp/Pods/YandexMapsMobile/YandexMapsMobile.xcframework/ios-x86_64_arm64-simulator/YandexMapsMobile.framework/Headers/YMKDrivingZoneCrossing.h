#import <YandexMapsMobile/YMKGeometry.h>

/**
 * Undocumented
 */
@interface YMKDrivingZoneCrossing : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKSubpolyline *position;


+ (nonnull YMKDrivingZoneCrossing *)zoneCrossingWithPosition:(nonnull YMKSubpolyline *)position;


@end
