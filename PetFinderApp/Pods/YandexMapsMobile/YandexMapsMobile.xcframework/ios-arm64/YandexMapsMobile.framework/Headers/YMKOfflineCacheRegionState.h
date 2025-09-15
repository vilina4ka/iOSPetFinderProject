#import <Foundation/Foundation.h>

/**
 * The state of the region.
 * @attention This feature is not available in the free MapKit version.
 */
typedef NS_ENUM(NSUInteger, YMKOfflineCacheRegionState) {
    /**
     * Available for download on the server.
     */
    YMKOfflineCacheRegionStateAvailable,
    /**
     * Download in progress.
     */
    YMKOfflineCacheRegionStateDownloading,
    /**
     * Download is paused.
     */
    YMKOfflineCacheRegionStatePaused,
    /**
     * Cache data installation is finished.
     */
    YMKOfflineCacheRegionStateCompleted,
    /**
     * The region was completed but there is a newer version on the server.
     */
    YMKOfflineCacheRegionStateOutdated,
    /**
     * The region was removed from regions list and will never be updated
     */
    YMKOfflineCacheRegionStateUnsupported,
    /**
     * The region is significantly outdated or it contains invalid data. OCM
     * will redownload it automatically if autoupdate enabled.
     */
    YMKOfflineCacheRegionStateNeedUpdate
};
