#import <Foundation/Foundation.h>

@class YMKImagesImageDataDescriptor;

/**
 * Undocumented
 */
@protocol YMKImagesImageUrlProvider <NSObject>

/**
 * Generates an URL that is used to load described image.
 *
 * This method may be called on any thread. Its implementation must be thread-safe.
 */
- (nonnull NSString *)formatUrlWithDescriptor:(nonnull YMKImagesImageDataDescriptor *)descriptor;

@end
