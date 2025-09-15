#import <Foundation/Foundation.h>

@class YMKPolyline;
@class YMKSubpolyline;

/**
 * Undocumented
 */
@interface YMKSubpolylineHelper : NSObject

/**
 * Cuts subpolyline geometry from polyline.
 */
+ (nonnull YMKPolyline *)subpolylineWithPolyline:(nonnull YMKPolyline *)polyline
                                     subpolyline:(nonnull YMKSubpolyline *)subpolyline;

/**
 * Calculates length of subpolyline geometry.
 */
+ (double)subpolylineLengthWithPolyline:(nonnull YMKPolyline *)polyline
                            subpolyline:(nonnull YMKSubpolyline *)subpolyline;

@end
