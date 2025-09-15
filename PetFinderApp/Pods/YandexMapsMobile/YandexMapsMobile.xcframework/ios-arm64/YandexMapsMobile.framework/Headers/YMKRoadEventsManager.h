#import <YandexMapsMobile/YMKGeoObject.h>

@class YMKRoadEventsEventInfoSession;

/**
 * Undocumented
 */
typedef void(^YMKRoadEventsEventInfoSessionResponseHandler)(
    YMKGeoObject * _Nullable event,
    NSError * _Nullable error);

/**
 * Session for requesting road event info.
 */
@interface YMKRoadEventsEventInfoSession : NSObject

/**
 * One of the following errors can happen: YRTNotFoundError,
 * YRTNetworkError, YRTRemoteError.
 */
- (void)retryWithResponseHandler:(nonnull YMKRoadEventsEventInfoSessionResponseHandler)responseHandler;

/**
 * Undocumented
 */
- (void)cancel;

@end

/**
 * Undocumented
 */
@interface YMKRoadEventsManager : NSObject

/**
 * Begins asynchronous request for road event info.
 *
 * @param eventId ID of the event to request information for.
 * @param eventInfoListener Listener for result or error.
 */
- (nonnull YMKRoadEventsEventInfoSession *)requestEventInfoWithEventId:(nonnull NSString *)eventId
                                                       responseHandler:(nonnull YMKRoadEventsEventInfoSessionResponseHandler)responseHandler;

@end
