#import <Foundation/Foundation.h>

@class YMKProjection;

/**
 * Undocumented
 */
@interface YMKProjections : NSObject

+ (nonnull YMKProjection *)wgs84Mercator;

+ (nonnull YMKProjection *)sphericalMercator;

@end
