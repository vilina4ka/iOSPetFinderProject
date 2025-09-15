#import <Foundation/Foundation.h>

@class YMKPoint;
@class YMKPolyline;
@class YMKPolylineBuilder;

/**
 * A builder class for polyline elements.
 */
@interface YMKPolylineBuilder : NSObject

/**
 * Appends a polyline.
 */
- (void)appendWithPolyline:(nonnull YMKPolyline *)polyline;

/**
 * Appends a point.
 */
- (void)appendWithPoint:(nonnull YMKPoint *)point;

/**
 * Builds a polyline.
 */
- (nonnull YMKPolyline *)build;

@end

/**
 * Undocumented
 */
@interface YMKPolylineBuilderFactory : NSObject

/**
 * Undocumented
 */
+ (nonnull YMKPolylineBuilder *)create;

@end
