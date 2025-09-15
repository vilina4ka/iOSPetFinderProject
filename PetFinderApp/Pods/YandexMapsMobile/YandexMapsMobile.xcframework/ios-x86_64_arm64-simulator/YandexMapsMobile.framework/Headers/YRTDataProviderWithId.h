#import <Foundation/Foundation.h>

/**
 * Provides any data.
 */
@protocol YRTDataProviderWithId <NSObject>

/**
 * Use the same id for the identical data, to prevent repeated loading
 * of the same data into RAM and VRAM.
 *
 * This method may be called on any thread. Its implementation must be thread-safe.
 */
- (nonnull NSString *)providerId;

/**
 * Returns data.
 *
 * This method will be called on a background thread.
 */
- (nonnull NSData *)load;

@end
