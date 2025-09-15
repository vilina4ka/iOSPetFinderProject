#import <Foundation/Foundation.h>

@class YMKMapWindow;

/**
 * Listener for MapWindow size changes.
 */
@protocol YMKMapSizeChangedListener <NSObject>

/**
 * Called when MapWindow handles the platform SizeChanged event. param@
 * absolute Screen coordinates.
 */
- (void)onMapWindowSizeChangedWithMapWindow:(nonnull YMKMapWindow *)mapWindow
                                   newWidth:(NSInteger)newWidth
                                  newHeight:(NSInteger)newHeight;

@end
