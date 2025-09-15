#import <Foundation/Foundation.h>

/**
 * Type of search layer's search requests.
 */
typedef NS_ENUM(NSUInteger, YMKSearchLayerRequestType) {
    /**
     * Primary request initiated via new query methods.
     */
    YMKSearchLayerRequestTypeNewQuery,
    /**
     * Manual resubmit on search layer.
     */
    YMKSearchLayerRequestTypeManualResubmit,
    /**
     * Request to fetch next page of results.
     */
    YMKSearchLayerRequestTypeFetchNextPage,
    /**
     * Request was initiated by map moved via API call.
     */
    YMKSearchLayerRequestTypeMapMoveByApp,
    /**
     * Request was initiated by map moved via user gesture.
     */
    YMKSearchLayerRequestTypeMapMoveByGesture
};
