#import <Foundation/Foundation.h>

/**
 * Listener to handle region list updated
 * @attention This feature is not available in the free MapKit version.
 */
@protocol YMKOfflineMapRegionListUpdatesListener <NSObject>

/**
 * Undocumented
 */
- (void)onListUpdated;

@end
