#import <Foundation/Foundation.h>

/**
 * A point at the specified coordinates.
 */
@interface YMKPoint : NSObject

/**
 * The point's latitude.
 */
@property (nonatomic, readonly) double latitude;

/**
 * The point's longitude.
 */
@property (nonatomic, readonly) double longitude;


+ (nonnull YMKPoint *)pointWithLatitude:( double)latitude
                              longitude:( double)longitude;


@end
