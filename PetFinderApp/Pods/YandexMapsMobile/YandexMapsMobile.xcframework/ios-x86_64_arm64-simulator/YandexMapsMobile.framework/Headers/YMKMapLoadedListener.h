#import <Foundation/Foundation.h>

@class YMKMapLoadStatistics;

/**
 * Listener interface for when the map has finished loading. This occurs
 * after all tiles required to render the map have been fetched, and are
 * ready to be rendered. This event will not fire if the map never loads
 * due to connectivity issues, or if the map is continuously changing
 * and never completes loading due to the user constantly interacting
 * with the map.
 */
@protocol YMKMapLoadedListener <NSObject>

/**
 * Called after the map has finished loading all visible tiles. This
 * will only be called once. You must set another listener if you want
 * to be notified again.
 */
- (void)onMapLoadedWithStatistics:(nonnull YMKMapLoadStatistics *)statistics;

@end
