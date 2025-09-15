#import <Foundation/Foundation.h>

/**
 * Base abstract class for an object event. Layers that produce object
 * event callbacks need to provide derived event classes.
 */
@interface YMKObjectEvent : NSObject

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
