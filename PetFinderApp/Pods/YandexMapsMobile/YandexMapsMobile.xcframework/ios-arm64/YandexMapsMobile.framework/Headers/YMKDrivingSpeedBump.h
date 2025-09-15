#import <YandexMapsMobile/YMKGeometry.h>

/**
 * A speed bump object.
 */
@interface YMKDrivingSpeedBump : NSObject

/**
 * The position of speed bump.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;


+ (nonnull YMKDrivingSpeedBump *)speedBumpWithPosition:(nonnull YMKPolylinePosition *)position;


@end
