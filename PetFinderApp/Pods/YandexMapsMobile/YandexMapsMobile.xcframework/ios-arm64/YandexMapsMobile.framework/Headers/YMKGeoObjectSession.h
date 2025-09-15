#import <Foundation/Foundation.h>

@class YMKGeoObject;

/**
 * Undocumented
 */
typedef void(^YMKGeoObjectSessionGeoObjectHandler)(
    YMKGeoObject * _Nullable obj,
    NSError * _Nullable error);

/**
 * The interface for working with the session.
 */
@interface YMKGeoObjectSession : NSObject

/**
 * Cancels the current request.
 */
- (void)cancel;

/**
 * Retries the last request. Cancels the current request if it is
 * active.
 */
- (void)retryWithGeoObjectHandler:(nonnull YMKGeoObjectSessionGeoObjectHandler)geoObjectHandler;

@end
