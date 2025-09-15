#import <Foundation/Foundation.h>

@class YMKDataSourceLayer;

/**
 * Interface for working with the layer.
 */
@interface YMKLayer : NSObject

/**
 * Removes the layer from the map. The object becomes invalid after
 * that.
 */
- (void)remove;

/**
 * Undocumented
 */
- (nonnull YMKDataSourceLayer *)dataSourceLayer;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
