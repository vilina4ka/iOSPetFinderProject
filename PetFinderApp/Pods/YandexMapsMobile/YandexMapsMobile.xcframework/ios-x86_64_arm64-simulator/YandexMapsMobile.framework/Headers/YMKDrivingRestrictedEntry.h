#import <YandexMapsMobile/YMKGeometry.h>

/**
 * A restricted entry object.
 */
@interface YMKDrivingRestrictedEntry : NSObject

/**
 * The position of the restricted entry.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;


+ (nonnull YMKDrivingRestrictedEntry *)restrictedEntryWithPosition:(nonnull YMKPolylinePosition *)position;


@end
