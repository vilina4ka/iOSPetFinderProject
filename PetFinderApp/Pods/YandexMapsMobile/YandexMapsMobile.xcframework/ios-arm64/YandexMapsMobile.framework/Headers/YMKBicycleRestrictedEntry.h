#import <YandexMapsMobile/YMKGeometry.h>

/**
 * Special point on the route (like gates).
 */
@interface YMKBicycleRestrictedEntry : NSObject

/**
 * Entry position on the route polyline.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;


+ (nonnull YMKBicycleRestrictedEntry *)restrictedEntryWithPosition:(nonnull YMKPolylinePosition *)position;


@end
