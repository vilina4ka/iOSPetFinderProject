#import <Foundation/Foundation.h>

/**
 * Listener to handle region information.
 * @attention This feature is not available in the free MapKit version.
 */
@protocol YMKOfflineCacheRegionListener <NSObject>

/**
 * Region state was changed.
 */
- (void)onRegionStateChangedWithRegionId:(NSUInteger)regionId;

/**
 * Progress of specific region download was updated.
 */
- (void)onRegionProgressWithRegionId:(NSUInteger)regionId;

@end
