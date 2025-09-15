#import <Foundation/Foundation.h>

@class YMKCluster;

/**
 * Undocumented
 */
@protocol YMKClusterTapListener <NSObject>

/**
 * Called when cluster is tapped. Return true if the event was handled.
 * Otherwise it will be passed to underlying objects.
 */
- (BOOL)onClusterTapWithCluster:(nonnull YMKCluster *)cluster;

@end
