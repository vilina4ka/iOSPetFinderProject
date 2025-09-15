#import <YandexMapsMobile/YMKBicycleWeight.h>
#import <YandexMapsMobile/YMKGeometry.h>

/**
 * Leg of the route.
 */
@interface YMKBicycleLeg : NSObject

/**
 * Quantitative characteristics of the route leg.
 */
@property (nonatomic, readonly, nonnull) YMKBicycleWeight *weight;

/**
 * Path of the route polyline for the route leg.
 */
@property (nonatomic, readonly, nonnull) YMKSubpolyline *geometry;


+ (nonnull YMKBicycleLeg *)legWithWeight:(nonnull YMKBicycleWeight *)weight
                                geometry:(nonnull YMKSubpolyline *)geometry;


@end
