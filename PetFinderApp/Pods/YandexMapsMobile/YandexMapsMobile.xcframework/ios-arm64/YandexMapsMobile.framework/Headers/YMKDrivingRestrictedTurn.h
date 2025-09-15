#import <YandexMapsMobile/YMKGeometry.h>

/**
 * Undocumented
 */
@interface YMKDrivingRestrictedTurn : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;


+ (nonnull YMKDrivingRestrictedTurn *)restrictedTurnWithPosition:(nonnull YMKPolylinePosition *)position;


@end
