#import <Foundation/Foundation.h>

@class YMKLogoAlignment;
@class YMKLogoPadding;

/**
 * The object that allows to control logo display properties.
 */
@interface YMKLogo : NSObject

/**
 * Set logo alignment in the container.
 */
- (void)setAlignmentWithAlignment:(nonnull YMKLogoAlignment *)alignment;

/**
 * Set logo padding relative to the left/right and top/bottom edges.
 * Values must be positive.
 */
- (void)setPaddingWithPadding:(nonnull YMKLogoPadding *)padding;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
