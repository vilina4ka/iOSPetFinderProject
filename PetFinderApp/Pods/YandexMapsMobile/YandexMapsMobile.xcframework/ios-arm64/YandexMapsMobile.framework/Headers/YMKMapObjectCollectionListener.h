#import <Foundation/Foundation.h>

@class YMKMapObject;

/**
 * The map object collection can't be modified in callbacks. A
 * runtime::RuntimeError exception is thrown if this happens.
 */
@protocol YMKMapObjectCollectionListener <NSObject>

/**
 * Called every time a new map object is added to the collection.
 */
- (void)onMapObjectAddedWithMapObject:(nonnull YMKMapObject *)mapObject;

/**
 * Called every time a map object is removed from the collection.
 */
- (void)onMapObjectRemovedWithMapObject:(nonnull YMKMapObject *)mapObject;

@end
