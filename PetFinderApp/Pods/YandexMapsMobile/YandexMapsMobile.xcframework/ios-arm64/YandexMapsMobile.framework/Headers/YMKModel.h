#import <YandexMapsMobile/YMKCallback.h>
#import <YandexMapsMobile/YMKPlacemarkPresentation.h>
#import <YandexMapsMobile/YRTDataProviderWithId.h>

@class YMKModelStyle;

/**
 * describes model presentation of PlacemarkMapObject
 */
@interface YMKModel : YMKPlacemarkPresentation
/**
 * The style properties (sclae, unitType, etc.) of the model placemark.
 * Note: The current style cannot be modified directly - you must reset
 * it to apply changes.
 */
@property (nonatomic, nonnull) YMKModelStyle *modelStyle;

/**
 * Sets gltf data provider.
 *
 * The class maintains a strong reference to the object in
 * the 'gltfDataProvider' parameter until it (the class) is invalidated.
 *
 * @param onFinished Called when the model is loaded.
 */
- (void)setDataWithGltfDataProvider:(nonnull id<YRTDataProviderWithId>)gltfDataProvider
                           callback:(nonnull YMKCallback)callback;

@end
