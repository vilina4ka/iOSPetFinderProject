#import <Foundation/Foundation.h>

@class YMKMasstransitRoute;

/**
 * Undocumented
 */
@interface YMKMasstransitRouteSerializer : NSObject

/**
 * Serializes the route.
 * @return Route's serialized representation. Empty array in case of any
 * errors.
 */
- (nonnull NSData *)saveWithRoute:(nonnull YMKMasstransitRoute *)route;

/**
 * Deserializes the route.
 * @return Deserialized Route. Null in case of any errors.
 */
- (nullable YMKMasstransitRoute *)loadWithData:(nonnull NSData *)data;

@end
