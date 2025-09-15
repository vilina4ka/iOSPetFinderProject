#import <YandexMapsMobile/YMKBaseMapObjectCollection.h>
#import <YandexMapsMobile/YMKClusterListener.h>
#import <YandexMapsMobile/YMKConflictResolutionMode.h>
#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YRTAnimatedImageProvider.h>
#import <YandexMapsMobile/YRTViewProvider.h>

#import <UIKit/UIKit.h>

@class YMKCircleMapObject;
@class YMKClusterizedPlacemarkCollection;
@class YMKIconStyle;
@class YMKMapObjectCollection;
@class YMKPlacemarkMapObject;
@class YMKPlacemarksStyler;
@class YMKPolygonMapObject;
@class YMKPolylineMapObject;

/**
 * A collection of map objects that can hold any set of MapObject items,
 * including nested collections.
 */
@interface YMKMapObjectCollection : YMKBaseMapObjectCollection

/**
 * Creates a new empty placemark and adds it to the current collection.
 */
- (nonnull YMKPlacemarkMapObject *)addPlacemark;

/**
 * Creates a new empty placemark and adds it to the current collection.
 * Callback can be used to setup placemark style and position Callback
 * will be called before MapObjectCollectionListener#onMapObjectAdded
 */
- (nonnull YMKPlacemarkMapObject *)addPlacemarkWithPlacemarkCreatedCallback:(nonnull YMKPlacemarkCreatedCallback)placemarkCreatedCallback;

/**
 * Creates a new empty placemark and adds it to the current collection.
 */
- (nonnull YMKPlacemarkMapObject *)addEmptyPlacemarkWithPoint:(nonnull YMKPoint *)point __attribute__((deprecated("Use addPlacemark() + setGeometry(point)")));

/**
 * Creates a new placemark with the default icon and style, and adds it
 * to the current collection.
 */
- (nonnull YMKPlacemarkMapObject *)addPlacemarkWithPoint:(nonnull YMKPoint *)point __attribute__((deprecated("Use addPlacemark() + setGeometry(point) + setIcon(your_own_blue_dot_icon). Default icon (also known as blue dot) is no longer provided.")));

/**
 * Creates a new placemark with the default style and adds it to the
 * current collection.
 */
- (nonnull YMKPlacemarkMapObject *)addPlacemarkWithPoint:(nonnull YMKPoint *)point
                                                   image:(nonnull UIImage *)image __attribute__((deprecated("Use addPlacemark() + setGeometry(point) + setIcon(image, style)")));

/**
 * Creates a new placemark and adds it to the current collection. Hint:
 * to add a large amount of placemarks use addPlacemarks method.
 */
- (nonnull YMKPlacemarkMapObject *)addPlacemarkWithPoint:(nonnull YMKPoint *)point
                                                   image:(nonnull UIImage *)image
                                                   style:(nonnull YMKIconStyle *)style __attribute__((deprecated("Use addPlacemark() + setGeometry(point) + setIcon(image, style)")));

/**
 * Creates a new view placemark with default style and adds it to the
 * current collection.
 */
- (nonnull YMKPlacemarkMapObject *)addPlacemarkWithPoint:(nonnull YMKPoint *)point
                                                    view:(nonnull YRTViewProvider *)view __attribute__((deprecated("Use addPlacemark() + setGeometry(point) + setView(view)")));

/**
 * Creates a new view placemark and adds it to the current collection.
 */
- (nonnull YMKPlacemarkMapObject *)addPlacemarkWithPoint:(nonnull YMKPoint *)point
                                                    view:(nonnull YRTViewProvider *)view
                                                   style:(nonnull YMKIconStyle *)style __attribute__((deprecated("Use addPlacemark() + setGeometry(point) + setView(view, style)")));

/**
 * Creates a new placemark with animated icon and adds it to the current
 * collection.
 */
- (nonnull YMKPlacemarkMapObject *)addPlacemarkWithPoint:(nonnull YMKPoint *)point
                                           animatedImage:(nonnull id<YRTAnimatedImageProvider>)animatedImage
                                                   style:(nonnull YMKIconStyle *)style __attribute__((deprecated("Use addPlacemark() + setGeometry(point) + useAnimation() + setIcon(animatedImage, style)")));

/**
 * Creates new placemarks and adds them to the current collection.
 * Relevant for Android: this method provides better performance for
 * adding a large number of placemarks than multiple calls of
 * addPlacemark.
 */
- (nonnull NSArray<YMKPlacemarkMapObject *> *)addPlacemarksWithPoints:(nonnull NSArray<YMKPoint *> *)points
                                                                image:(nonnull UIImage *)image
                                                                style:(nonnull YMKIconStyle *)style __attribute__((deprecated("Use ClusterizedPlacemarkCollection")));

/**
 * Creates new empty placemarks and adds them to the current collection.
 *
 * Relevant for Android: this method provides better performance for
 * adding a large number of empty placemarks than multiple calls of
 * addEmptyPlacemark.
 */
- (nonnull NSArray<YMKPlacemarkMapObject *> *)addEmptyPlacemarksWithPoints:(nonnull NSArray<YMKPoint *> *)points __attribute__((deprecated("Use ClusterizedPlacemarkCollection")));

/**
 * Creates a new polyline and adds it to the current collection.
 */
- (nonnull YMKPolylineMapObject *)addPolylineWithPolyline:(nonnull YMKPolyline *)polyline;

/**
 * Creates a new polyline with an empty geometry and adds it to the
 * current collection.
 */
- (nonnull YMKPolylineMapObject *)addPolyline;

/**
 * Creates a new polygon and adds it to the current collection.
 */
- (nonnull YMKPolygonMapObject *)addPolygonWithPolygon:(nonnull YMKPolygon *)polygon;

/**
 * Creates a new circle and adds it to the current collection.
 */
- (nonnull YMKCircleMapObject *)addCircleWithCircle:(nonnull YMKCircle *)circle;

/**
 * Creates a new nested collection of map objects.
 */
- (nonnull YMKMapObjectCollection *)addCollection;

/**
 * Creates a new nested collection of clusterized placemarks.
 *
 * The class does not retain the object in the 'clusterListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 *
 * @param clusterListener Listener that controls cluster appearance once
 * they are added to the map.
 */
- (nonnull YMKClusterizedPlacemarkCollection *)addClusterizedPlacemarkCollectionWithClusterListener:(nonnull id<YMKClusterListener>)clusterListener;

/**
 * A styler for all placemarks in this collection, including placemarks
 * in child collections.
 */
- (nonnull YMKPlacemarksStyler *)placemarksStyler;

@end

/**
 * Undocumented
 */
@interface YMKRootMapObjectCollection : YMKMapObjectCollection
/**
 * Undocumented
 */
@property (nonatomic) YMKConflictResolutionMode conflictResolutionMode;

@end
