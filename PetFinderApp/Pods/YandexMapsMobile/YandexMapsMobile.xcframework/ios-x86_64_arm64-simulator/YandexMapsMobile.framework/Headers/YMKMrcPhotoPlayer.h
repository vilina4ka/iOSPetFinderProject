#import <Foundation/Foundation.h>

/**
 * :nodoc:
 */
@interface YMKMrcPhotoPlayer : NSObject

/**
 * Closes the opened photo and stops all player actions.
 */
- (void)reset;
/**
 * Current photo ID. Set to null after reset.
 *
 * Optional property, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *photoId;

/**
 * Shows transition arrows and allows switching photos.
 */
- (void)enableMove;

/**
 * Hides transition arrows and disallows switching photos.
 */
- (void)disableMove;

/**
 * Checks if switching photos is enabled.
 */
- (BOOL)moveEnabled;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
