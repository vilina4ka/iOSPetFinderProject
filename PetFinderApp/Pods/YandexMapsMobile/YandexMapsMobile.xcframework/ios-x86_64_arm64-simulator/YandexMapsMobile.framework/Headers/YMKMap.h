#import <YandexMapsMobile/YMKAnimation.h>
#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YMKIndoorStateListener.h>
#import <YandexMapsMobile/YMKLayer.h>
#import <YandexMapsMobile/YMKLayerOptions.h>
#import <YandexMapsMobile/YMKLayersGeoObjectTapListener.h>
#import <YandexMapsMobile/YMKLogo.h>
#import <YandexMapsMobile/YMKMapCameraListener.h>
#import <YandexMapsMobile/YMKMapInputListener.h>
#import <YandexMapsMobile/YMKMapLoadedListener.h>
#import <YandexMapsMobile/YMKMapMode.h>
#import <YandexMapsMobile/YMKMapType.h>
#import <YandexMapsMobile/YMKProjection.h>
#import <YandexMapsMobile/YMKScreenTypes.h>
#import <YandexMapsMobile/YMKTileDataSourceBuilder.h>

@class YMKCameraBounds;
@class YMKCameraPosition;
@class YMKGeoObjectSelectionMetadata;
@class YMKRootMapObjectCollection;
@class YMKVisibleRegion;

/**
 * Undocumented
 */
typedef void(^YMKMapCameraCallback)(
    BOOL completed);

/**
 * The object that is used to interact with the map.
 */
@interface YMKMap : NSObject
/**
 * @return Current camera position. Target position must be within
 * latitude [-90, 90] and longitude [-180, 180].
 */
@property (nonatomic, readonly, nonnull) YMKCameraPosition *cameraPosition;

/**
 * Calculates the camera position that projects the specified geometry
 * into the current focusRect, or the full view if the focusRect is not
 * set.
 */
- (nonnull YMKCameraPosition *)cameraPositionWithGeometry:(nonnull YMKGeometry *)geometry;

/**
 * Calculates the camera position that projects the specified geometry
 * into the custom focusRect.
 */
- (nonnull YMKCameraPosition *)cameraPositionWithGeometry:(nonnull YMKGeometry *)geometry
                                                focusRect:(nonnull YMKScreenRect *)focusRect;

/**
 * @return Camera position that projects the specified geometry into the
 * custom focusRect, with custom azimuth and tilt camera parameters. If
 * focus rect is not provided, current focus rect is used.
 */
- (nonnull YMKCameraPosition *)cameraPositionWithGeometry:(nonnull YMKGeometry *)geometry
                                                  azimuth:(float)azimuth
                                                     tilt:(float)tilt
                                                focusRect:(nullable YMKScreenRect *)focusRect;
/**
 * @return The map region that is currently visible. Region IS bounded
 * by latitude limits [-90, 90] and IS NOT bounded by longitude limits
 * [-180, 180]. If the longitude exceeds its limits, we see the world's
 * edge and another instance of the world beyond this edge.
 */
@property (nonatomic, readonly, nonnull) YMKVisibleRegion *visibleRegion;

/**
 * @return The map region that is visible from the given camera
 * position. Region IS bounded by latitude limits [-90, 90] and IS NOT
 * bounded by longitude limits [-180, 180]. If the longitude exceeds its
 * limits, we see the world's edge and another instance of the world
 * beyond this edge.
 */
- (nonnull YMKVisibleRegion *)visibleRegionWithCameraPosition:(nonnull YMKCameraPosition *)cameraPosition;

/**
 * Changes camera position. Can cancel a previous unfinished movement.
 *
 * @param animation Required. Defines animation parameters. @see
 * mapkit.Animation for more details.
 * @param cameraCallback A function that takes the bool argument marking
 * the camera action complete. Invoked when: <ul><li>A camera action is
 * cancelled (for example, as a result of a subsequent request for
 * camera movement), passing false as an argument.</li> <li>A camera
 * action finished successfully, passing true as an argument.</li></ul>
 */
- (void)moveWithCameraPosition:(nonnull YMKCameraPosition *)cameraPosition
                     animation:(nonnull YMKAnimation *)animation
                cameraCallback:(nullable YMKMapCameraCallback)cameraCallback;

/**
 * Immediately changes the camera position. Can cancel a previous
 * unfinished movement.
 */
- (void)moveWithCameraPosition:(nonnull YMKCameraPosition *)cameraPosition;
/**
 * Undocumented
 */
@property (nonatomic, readonly, readonly, nonnull) YMKCameraBounds *cameraBounds;
/**
 * If enabled, night mode will reduce map brightness and improve
 * contrast.
 */
@property (nonatomic, getter=isNightModeEnabled) BOOL nightModeEnabled;
/**
 * Enable/disable zoom gestures, for example: - pinch - double tap (zoom
 * in) - tap with two fingers (zoom out)
 */
@property (nonatomic, getter=isZoomGesturesEnabled) BOOL zoomGesturesEnabled;
/**
 * Enable/disable scroll gestures, such as the pan gesture.
 */
@property (nonatomic, getter=isScrollGesturesEnabled) BOOL scrollGesturesEnabled;
/**
 * Enable/disable tilt gestures, such as parallel pan with two fingers.
 */
@property (nonatomic, getter=isTiltGesturesEnabled) BOOL tiltGesturesEnabled;
/**
 * Enable/disable rotation gestures, such as rotation with two fingers.
 */
@property (nonatomic, getter=isRotateGesturesEnabled) BOOL rotateGesturesEnabled;
/**
 * Removes the 300 ms delay in emitting a tap gesture. However, a
 * double-tap will emit a tap gesture along with a double-tap.
 */
@property (nonatomic, getter=isFastTapEnabled) BOOL fastTapEnabled;
/**
 * Sets the base map type.
 */
@property (nonatomic) YMKMapType mapType;

/**
 * Adds input listeners.
 *
 * The class does not retain the object in the 'inputListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)addInputListenerWithInputListener:(nonnull id<YMKMapInputListener>)inputListener;

/**
 * Removes input listeners.
 */
- (void)removeInputListenerWithInputListener:(nonnull id<YMKMapInputListener>)inputListener;

/**
 * Adds camera listeners.
 *
 * The class does not retain the object in the 'cameraListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)addCameraListenerWithCameraListener:(nonnull id<YMKMapCameraListener>)cameraListener;

/**
 * Removes camera listeners.
 */
- (void)removeCameraListenerWithCameraListener:(nonnull id<YMKMapCameraListener>)cameraListener;

/**
 * Sets a map loaded listener.
 *
 * The class does not retain the object in the 'mapLoadedListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)setMapLoadedListenerWithMapLoadedListener:(nullable id<YMKMapLoadedListener>)mapLoadedListener;
/**
 * @return List of map objects associated with the map. The layerId for
 * this collection can be retrieved via LayerIds.mapObjectsLayerId
 */
@property (nonatomic, readonly, readonly, nonnull) YMKRootMapObjectCollection *mapObjects;

/**
 * Adds a tap listener that is used to obtain brief geo object info.
 *
 * The class does not retain the object in the 'tapListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)addTapListenerWithTapListener:(nonnull id<YMKLayersGeoObjectTapListener>)tapListener;

/**
 * Removes a tap listener that is used to obtain brief geo object info.
 */
- (void)removeTapListenerWithTapListener:(nonnull id<YMKLayersGeoObjectTapListener>)tapListener;

/**
 * Resets the currently selected geo object.
 */
- (void)deselectGeoObject;

/**
 * Selects a geo object with the specified objectId in the specified
 * layerId. If the object is not currently on the screen, it is selected
 * anyway, but the user will not actually see that. You need to move the
 * camera in addition to this call to be sure that the selected object
 * is visible for the user. GeoObjectSelectionMetadata can be extracted
 * from the geo object's metadata container when the user taps on a geo
 * object.
 */
- (void)selectGeoObjectWithSelectionMetaData:(nonnull YMKGeoObjectSelectionMetadata *)selectionMetaData;
/**
 * Yandex logo object.
 */
@property (nonatomic, readonly, readonly, nonnull) YMKLogo *logo;
/**
 * Limits the number of visible basemap POIs.
 *
 * Optional property, can be nil.
 */
@property (nonatomic, nullable) NSNumber *poiLimit;
/**
 * Enables/disables indoor plans on the map. Disabled by default.
 */
@property (nonatomic, getter=isIndoorEnabled) BOOL indoorEnabled;

/**
 * Subscribe to indoor state change events.
 *
 * The class does not retain the object in the 'indoorStateListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)addIndoorStateListenerWithIndoorStateListener:(nonnull id<YMKIndoorStateListener>)indoorStateListener;

/**
 * Unsubscribe from indoor state change events.
 */
- (void)removeIndoorStateListenerWithIndoorStateListener:(nonnull id<YMKIndoorStateListener>)indoorStateListener;

/**
 * Applies JSON style transformations to the map. Same as setMapStyle(0,
 * style). Affects VectorMap and Hybrid map types. Set to empty string
 * to clear previous styling. Returns true if the style was successfully
 * parsed, and false otherwise. If the returned value is false, the
 * current map style remains unchanged.
 */
- (BOOL)setMapStyleWithStyle:(nonnull NSString *)style;

/**
 * Applies JSON style transformations to the map. Replaces previous
 * styling with the specified ID (if such exists). Stylings are applied
 * in an ascending order. Affects VectorMap and Hybrid map types. Set to
 * empty string to clear previous styling with the specified ID. Returns
 * true if the style was successfully parsed, and false otherwise. If
 * the returned value is false, the current map style remains unchanged.
 */
- (BOOL)setMapStyleWithId:(NSInteger)id
                    style:(nonnull NSString *)style;

/**
 * Resets all JSON style transformations applied to the map.
 */
- (void)resetMapStyles;

/**
 * Forces the map to be flat. true - All loaded tiles start showing the
 * "flatten out" animation; all new tiles do not start 3D animation.
 * false - All tiles start showing the "rise up" animation.
 */
- (void)set2DModeWithEnable:(BOOL)enable;

/**
 * Creates a new independent map object collection linked to the
 * specified layer ID. Sublayers will be added after corresponding
 * sublayers of the topmost layer.
 */
- (nonnull YMKRootMapObjectCollection *)addMapObjectLayerWithLayerId:(nonnull NSString *)layerId;

/**
 * Provides map projection
 */
- (nonnull YMKProjection *)projection;
/**
 * Selects one of predefined map style modes optimized for particular
 * use case(transit, driving, etc). Resets json styles set with
 * setMapStyle. MapMode.Map by deafult.
 */
@property (nonatomic) YMKMapMode mode;
/**
 * Enables hd mode of displayed content
 */
@property (nonatomic, getter=isHdModeEnabled) BOOL hdModeEnabled;

/**
 * Erases tiles, caches, etc. Does not trigger the next frame
 * generation.
 */
- (void)wipe;

/**
 * :nodoc:
 * Starts capturing tile load metrics.
 */
- (void)startTileLoadMetricsCapture;

/**
 * :nodoc:
 * Stops capturing tile load metrics and returns captured metrics as a
 * string.
 */
- (nonnull NSString *)stopTileLoadMetricsCapture;
/**
 * Enables rich textured 3d content on basemap.
 */
@property (nonatomic, getter=isAwesomeModelsEnabled) BOOL awesomeModelsEnabled;

/**
 * Adds tile layer.
 */
- (nonnull YMKLayer *)addTileLayerWithLayerId:(nonnull NSString *)layerId
                                 layerOptions:(nonnull YMKLayerOptions *)layerOptions
                         createTileDataSource:(nonnull YMKCreateTileDataSource)createTileDataSource;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
