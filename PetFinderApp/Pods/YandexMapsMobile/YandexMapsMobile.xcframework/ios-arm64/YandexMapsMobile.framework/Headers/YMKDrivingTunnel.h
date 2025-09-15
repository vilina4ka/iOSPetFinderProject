#import <YandexMapsMobile/YMKGeometry.h>

/**
 * Undocumented
 */
@interface YMKDrivingTunnel : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKSubpolyline *position;


+ (nonnull YMKDrivingTunnel *)tunnelWithPosition:(nonnull YMKSubpolyline *)position;


@end
