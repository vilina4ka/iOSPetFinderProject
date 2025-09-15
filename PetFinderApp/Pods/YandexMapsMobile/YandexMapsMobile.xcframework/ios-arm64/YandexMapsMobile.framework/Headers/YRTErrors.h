#import <YandexMapsMobile/YRTError.h>

/**
 * Server responded in unexpected way: unparsable content, wrong content
 * or unexpected HTTP code.
 */
@interface YRTRemoteError : YRTError

@end

/**
 * Client request is invalid (server returned the 400 'Bad Request'
 * response).
 */
@interface YRTBadRequestError : YRTRemoteError

@end

/**
 * Requested object has not been found. Most likely, your link is
 * outdated or the object has been deleted.
 */
@interface YRTNotFoundError : YRTRemoteError

@end

/**
 * Request entity is too large.
 */
@interface YRTRequestEntityTooLargeError : YRTRemoteError

@end

/**
 * You are not allowed to access the requested object.
 */
@interface YRTForbiddenError : YRTRemoteError

@end

/**
 * You do not have a valid MapKit API key.
 */
@interface YRTUnauthorizedError : YRTRemoteError

@end

/**
 * Failed to retrieve data due to network instability.
 */
@interface YRTNetworkError : YRTError

@end
