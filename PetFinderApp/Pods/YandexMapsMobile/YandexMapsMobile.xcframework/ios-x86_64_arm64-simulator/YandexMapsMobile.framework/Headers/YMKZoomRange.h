#import <Foundation/Foundation.h>

/**
 * Describes the range of zoom levels. Zooming is allowed between zMin
 * and zMax values.
 */
@interface YMKZoomRange : NSObject

/**
 * Lower limit of zoom range, inclusive.
 */
@property (nonatomic, readonly) NSUInteger zMin;

/**
 * Upper limit of zoom range, exclusive.
 */
@property (nonatomic, readonly) NSUInteger zMax;


+ (nonnull YMKZoomRange *)zoomRangeWithZMin:( NSUInteger)zMin
                                       zMax:( NSUInteger)zMax;


@end
