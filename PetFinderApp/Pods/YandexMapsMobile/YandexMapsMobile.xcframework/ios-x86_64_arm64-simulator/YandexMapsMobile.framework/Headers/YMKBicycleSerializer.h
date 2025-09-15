#import <Foundation/Foundation.h>

@class YMKBicycleRoute;

/**
 * Undocumented
 */
@interface YMKBicycleRouteSerializer : NSObject

/**
 * Returns a route's serialized representation. Returns an empty array
 * if there are any errors.
 */
+ (nonnull NSData *)saveWithRoute:(nonnull YMKBicycleRoute *)route;

/**
 * Returns a deserialized route. Returns null on error.
 */
+ (nonnull YMKBicycleRoute *)loadWithData:(nonnull NSData *)data;

@end
