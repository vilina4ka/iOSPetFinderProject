#import <YandexMapsMobile/YMKBicycleWeight.h>
#import <YandexMapsMobile/YMKGeometry.h>

/**
 * Section of the route.
 */
@interface YMKBicycleSection : NSObject

/**
 * Quantitative characteristics of a route or route section.
 */
@property (nonatomic, readonly, nonnull) YMKBicycleWeight *weight;

/**
 * Path of the route polyline for this section.
 */
@property (nonatomic, readonly, nonnull) YMKSubpolyline *geometry;


+ (nonnull YMKBicycleSection *)sectionWithWeight:(nonnull YMKBicycleWeight *)weight
                                        geometry:(nonnull YMKSubpolyline *)geometry;


@end
