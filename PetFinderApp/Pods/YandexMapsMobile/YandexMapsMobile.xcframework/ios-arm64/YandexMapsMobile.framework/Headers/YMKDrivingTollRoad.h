#import <YandexMapsMobile/YMKGeometry.h>

/**
 * Undocumented
 */
@interface YMKDrivingTollRoad : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKSubpolyline *position;


+ (nonnull YMKDrivingTollRoad *)tollRoadWithPosition:(nonnull YMKSubpolyline *)position;


@end
