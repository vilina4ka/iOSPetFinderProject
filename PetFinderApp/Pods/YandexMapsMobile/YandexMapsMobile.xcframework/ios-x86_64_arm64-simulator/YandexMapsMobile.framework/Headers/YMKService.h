#import <YandexMapsMobile/YMKPoint.h>

@class YMKPanoramaServiceSearchSession;

/**
 * Undocumented
 */
typedef void(^YMKPanoramaServiceSearchHandler)(
    NSString * _Nullable panoramaId,
    NSError * _Nullable error);

/**
 * The interface that handles panoramas.
 */
@interface YMKPanoramaService : NSObject

/**
 * Requests the ID of the panorama that is closest to the specified
 * position.
 *
 * @param position Position to find the nearest panoramaId to.
 * @param searchListener Receives the panorama search result.
 *
 * @return Session handle that should be stored until searchListener is
 * notified.
 */
- (nonnull YMKPanoramaServiceSearchSession *)findNearestWithPosition:(nonnull YMKPoint *)position
                                                       searchHandler:(nonnull YMKPanoramaServiceSearchHandler)searchHandler;

@end

/**
 * Session for receiving the result of the findNearest() method.
 *
 * Should be stored until the listener is notified. Can be used to
 * cancel the active request. Can be used to retry the last request (for
 * example, if it failed).
 */
@interface YMKPanoramaServiceSearchSession : NSObject

/**
 * Retries the last request.
 */
- (void)retryWithSearchHandler:(nonnull YMKPanoramaServiceSearchHandler)searchHandler;

/**
 * Cancels the active request.
 */
- (void)cancel;

@end
