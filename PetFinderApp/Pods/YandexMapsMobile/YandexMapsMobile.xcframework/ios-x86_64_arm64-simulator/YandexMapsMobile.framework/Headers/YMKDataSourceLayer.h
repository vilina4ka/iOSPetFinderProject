#import <YandexMapsMobile/YMKDataSource.h>
#import <YandexMapsMobile/YMKLayerLoadedListener.h>

/**
 * Undocumented
 */
@interface YMKDataSourceLayer : NSObject
/**
 * Manages visibility of the layer.
 */
@property (nonatomic, getter=isActive) BOOL active;

/**
 * Clears all cached tiles and starts new requests for tiles that are
 * displayed.
 */
- (void)clear;

/**
 * Applies JSON style transformation to the layer. Replaces previous
 * styling with the specified ID (if such exists). Stylings are applied
 * in an ascending order. Set to empty string to clear previous styling
 * with the specified ID. Returns true if the style was successfully
 * parsed and false otherwise. If the returned value is false, the
 * current style remains unchanged.
 */
- (BOOL)setStyleWithId:(NSInteger)id
                 style:(nonnull NSString *)style;

/**
 * Resets all JSON style transformations applied to the layer.
 */
- (void)resetStyles;

/**
 * Sets layer loaded listener.
 *
 * The class does not retain the object in the 'layerLoadedListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)setLayerLoadedListenerWithLayerLoadedListener:(nullable id<YMKLayerLoadedListener>)layerLoadedListener;

/**
 * Removes the data source layer from the parent layer. The object
 * becomes invalid after that.
 */
- (void)remove;

/**
 * Sets data source listener. Use it to invalidate data source.
 * Temporary solution until https://st.yandex-team.ru/MAPSMOBCORE-20531
 * is done
 *
 * The class does not retain the object in the 'dataSourceListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)setDataSourceListenerWithDataSourceListener:(nullable id<YMKDataSourceListener>)dataSourceListener;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
