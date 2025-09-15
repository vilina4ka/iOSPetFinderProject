#import <YandexMapsMobile/YMKMapObject.h>
#import <YandexMapsMobile/YMKMapObjectCollectionListener.h>
#import <YandexMapsMobile/YMKMapObjectVisitor.h>

@class YMKPlacemarkMapObject;

/**
 * Undocumented
 */
typedef void(^YMKPlacemarkCreatedCallback)(
    YMKPlacemarkMapObject * _Nonnull placemark);

/**
 * Undocumented
 */
@interface YMKBaseMapObjectCollection : YMKMapObject

/**
 * Traverses through the collection with a visitor object. Used for
 * iteration over map objects in the collection.
 *
 * The class does not retain the object in the 'mapObjectVisitor' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)traverseWithMapObjectVisitor:(nonnull id<YMKMapObjectVisitor>)mapObjectVisitor;

/**
 * Removes the given map object from the collection.
 */
- (void)removeWithMapObject:(nonnull YMKMapObject *)mapObject;

/**
 * Removes all map objects from the collection.
 */
- (void)clear;

/**
 * Adds a listener to track notifications of changes to the collection.
 *
 * The class does not retain the object in the 'collectionListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)addListenerWithCollectionListener:(nonnull id<YMKMapObjectCollectionListener>)collectionListener;

/**
 * Removes a listener.
 */
- (void)removeListenerWithCollectionListener:(nonnull id<YMKMapObjectCollectionListener>)collectionListener;

@end
