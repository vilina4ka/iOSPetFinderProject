#import <YandexMapsMobile/YMKClusterTapListener.h>

@class YMKPlacemarkMapObject;

/**
 * Undocumented
 */
@interface YMKCluster : NSObject
/**
 * A list of placemarks the cluster contains.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPlacemarkMapObject *> *placemarks;
/**
 * Cluster size.
 */
@property (nonatomic, readonly) NSUInteger size;
/**
 * Cluster representation displayed on the map.
 */
@property (nonatomic, readonly, readonly, nonnull) YMKPlacemarkMapObject *appearance;

/**
 * Adds a tap listener for cluster.
 *
 * The class does not retain the object in the 'clusterTapListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)addClusterTapListenerWithClusterTapListener:(nonnull id<YMKClusterTapListener>)clusterTapListener;

/**
 * Removes tap listener.
 */
- (void)removeClusterTapListenerWithClusterTapListener:(nonnull id<YMKClusterTapListener>)clusterTapListener;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
