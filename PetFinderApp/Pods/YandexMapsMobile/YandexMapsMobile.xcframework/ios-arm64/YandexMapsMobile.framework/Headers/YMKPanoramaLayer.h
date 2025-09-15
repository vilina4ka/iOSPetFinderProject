#import <Foundation/Foundation.h>

/**
 * Panorama coverage layer
 */
@interface YMKPanoramaLayer : NSObject

/**
 * Enables or disables the street coverage layer.
 */
- (void)setStreetPanoramaVisibleWithOn:(BOOL)on;

/**
 * Enables or disables the airship icons.
 */
- (void)setAirshipPanoramaVisibleWithOn:(BOOL)on;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
