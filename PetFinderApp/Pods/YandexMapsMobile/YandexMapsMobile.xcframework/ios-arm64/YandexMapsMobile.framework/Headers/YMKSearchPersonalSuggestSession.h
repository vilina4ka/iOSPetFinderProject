#import <Foundation/Foundation.h>

/**
 * Undocumented
 */
typedef void(^YMKSearchDeleteAllPersonalSuggestSessionPersonalSuggestHandler)(
    NSError * _Nullable error);

/**
 * Interface to handle remove all user personalized suggest request.
 * Allows request cancellation and retry.
 */
@interface YMKSearchDeleteAllPersonalSuggestSession : NSObject

/**
 * Cancels the current request.
 */
- (void)cancel;

/**
 * Retries the last request. If there is an active request, it is
 * cancelled.
 *
 * @param personalSuggestListener Listener to handle result.
 */
- (void)retryWithPersonalSuggestHandler:(nonnull YMKSearchDeleteAllPersonalSuggestSessionPersonalSuggestHandler)personalSuggestHandler;

@end
