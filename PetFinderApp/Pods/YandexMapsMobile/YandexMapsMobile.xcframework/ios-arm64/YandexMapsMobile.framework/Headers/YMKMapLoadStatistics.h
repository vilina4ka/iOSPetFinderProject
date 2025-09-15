#import <Foundation/Foundation.h>

/**
 * The time it took to load map elements.
 */
@interface YMKMapLoadStatistics : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSTimeInterval curZoomGeometryLoaded;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSTimeInterval curZoomPlacemarksLoaded;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSTimeInterval curZoomLabelsLoaded;

/**
 * The time it took to load delayed geometry.
 */
@property (nonatomic, readonly) NSTimeInterval delayedGeometryLoaded;

/**
 * The time it took to load models.
 */
@property (nonatomic, readonly) NSTimeInterval curZoomModelsLoaded;

/**
 * The time it took to load all map objects.
 */
@property (nonatomic, readonly) NSTimeInterval fullyLoaded;

/**
 * The time it took for all map objects to appear.
 */
@property (nonatomic, readonly) NSTimeInterval fullyAppeared;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSInteger renderObjectCount;

/**
 * Tile memory usage in bytes
 */
@property (nonatomic, readonly) NSUInteger tileMemoryUsage;


+ (nonnull YMKMapLoadStatistics *)mapLoadStatisticsWithCurZoomGeometryLoaded:( NSTimeInterval)curZoomGeometryLoaded
                                                     curZoomPlacemarksLoaded:( NSTimeInterval)curZoomPlacemarksLoaded
                                                         curZoomLabelsLoaded:( NSTimeInterval)curZoomLabelsLoaded
                                                       delayedGeometryLoaded:( NSTimeInterval)delayedGeometryLoaded
                                                         curZoomModelsLoaded:( NSTimeInterval)curZoomModelsLoaded
                                                                 fullyLoaded:( NSTimeInterval)fullyLoaded
                                                               fullyAppeared:( NSTimeInterval)fullyAppeared
                                                           renderObjectCount:( NSInteger)renderObjectCount
                                                             tileMemoryUsage:( NSUInteger)tileMemoryUsage;


@end
