#import <Foundation/Foundation.h>

@class YMKLocationManager;
@class YMKLocationViewSource;

/**
 * Undocumented
 */
@interface YMKLocationViewSourceFactory : NSObject

/**
 * Location view source.
 */
+ (nonnull YMKLocationViewSource *)createLocationViewSourceWithLocationManager:(nonnull YMKLocationManager *)locationManager;

@end
