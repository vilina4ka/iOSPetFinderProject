#import <YandexMapsMobile/YMKBaseMapObjectCollection.h>
#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YRTAnimatedImageProvider.h>
#import <YandexMapsMobile/YRTViewProvider.h>

#import <UIKit/UIKit.h>

@class YMKIconStyle;
@class YMKPlacemarkMapObject;

/**
 * A collection that displays large groups of placemarks efficiently.
 * Placemarks that are too close to each other with current zoom are
 * rendered as a single cluster. Placemarks and clusters are not shown
 * until clusterPlacemarks method is called explicitly.
 */
@interface YMKClusterizedPlacemarkCollection : YMKBaseMapObjectCollection

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
 * Hint: to add a large amount of empty placemarks use
 * addEmptyPlacemarks method.
 */
- (nonnull YMKPlacemarkMapObject *)addEmptyPlacemarkWithPoint:(nonnull YMKPoint *)point __attribute__((deprecated("Use addPlacemark() + setGeometry(point)")));

/**
 * Creates new empty placemarks and adds them to the current collection.
 *
 * Relevant for Android: this method provides better performance for
 * adding a large number of empty placemarks than multiple calls of
 * addEmptyPlacemark.
 */
- (nonnull NSArray<YMKPlacemarkMapObject *> *)addEmptyPlacemarksWithPoints:(nonnull NSArray<YMKPoint *> *)points;

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
                                                   image:(nonnull UIImage *)image __attribute__((deprecated("Use addPlacemark() + setGeometry(point) + setIcon(image)")));

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
                                                                style:(nonnull YMKIconStyle *)style;

/**
 * Updates clustered representations of placemark groups. This method
 * must be called explicitly to render placemarks and clusters when
 * collection is created and update them after collection change.
 *
 * @param clusterRadius Minimal distance in units between objects that
 * remain separate. The size of the unit is equal to the size of a pixel
 * when the camera position's tilt is equal to 0 and the scale factor is
 * equal to 1.
 * @param minZoom Minimal zoom level that displays clusters. All
 * placemarks will be rendered separately at more detailed zoom levels.
 * The value will be clipped between 0 and 19 (most detailed zoom).
 */
- (void)clusterPlacemarksWithClusterRadius:(double)clusterRadius
                                   minZoom:(NSUInteger)minZoom;

@end
