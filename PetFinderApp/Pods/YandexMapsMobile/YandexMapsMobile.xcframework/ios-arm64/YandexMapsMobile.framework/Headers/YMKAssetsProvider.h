#import <YandexMapsMobile/YMKIconStyle.h>

#import <UIKit/UIKit.h>

@class YMKSearchResultItem;
@class YMKSize;

/**
 * Possible placemark icon types
 */
typedef NS_ENUM(NSUInteger, YMKPlacemarkIconType) {
    /**
     * No icon. This type will never be passed to `AssetsProvider` methods.
     */
    YMKPlacemarkIconTypeNone,
    /**
     * Dust.
     */
    YMKPlacemarkIconTypeDust,
    /**
     * Dust, search result is already visited.
     */
    YMKPlacemarkIconTypeDustVisited,
    /**
     * Icon.
     */
    YMKPlacemarkIconTypeIcon,
    /**
     * Icon, search result is already visited.
     */
    YMKPlacemarkIconTypeIconVisited,
    /**
     * One-line label to the left of the icon.
     */
    YMKPlacemarkIconTypeLabelShortLeft,
    /**
     * One-line label to the right of the icon.
     */
    YMKPlacemarkIconTypeLabelShortRight,
    /**
     * Detailed label to the left of the icon.
     */
    YMKPlacemarkIconTypeLabelDetailedLeft,
    /**
     * Detailed label to the right of the icon.
     */
    YMKPlacemarkIconTypeLabelDetailedRight,
    /**
     * Search result is selected.
     */
    YMKPlacemarkIconTypeSelected
};

/**
 * Interface for providing images, image sizes and icon styles to the
 * search layer. Call with static_cast<int>(PlacemarkIconType) in all
 * methods.
 */
@protocol YMKAssetsProvider <NSObject>

/**
 * Returns an image for certain placemark type with given search result
 *
 * This method will be called on a background thread.
 */
- (nonnull UIImage *)imageWithSearchResult:(nonnull YMKSearchResultItem *)searchResult
                         placemarkIconType:(NSInteger)placemarkIconType;

/**
 * Returns the size of the icon of certain placemark type with given
 * search result
 *
 * This method may be called on any thread. Its implementation must be thread-safe.
 */
- (nonnull YMKSize *)sizeWithSearchResult:(nonnull YMKSearchResultItem *)searchResult
                        placemarkIconType:(NSInteger)placemarkIconType;

/**
 * Returns the icon style for certain placemark type with given search
 * result. If obtainAdIcons mode is enabled, IconStyle.anchor will be
 * replaced for advertisement pins
 *
 * This method may be called on any thread. Its implementation must be thread-safe.
 */
- (nonnull YMKIconStyle *)iconStyleWithSearchResult:(nonnull YMKSearchResultItem *)searchResult
                                  placemarkIconType:(NSInteger)placemarkIconType;

/**
 * Returns `true` if provider is able to provide images for given search
 * result and placemark types of `LabelShortLeft`, `LabelShortRight`,
 * `LabelDetailedLeft` and `LabelDetailedRight`. If `false` is returned
 * then no label would be shown for this search result.
 *
 * This method may be called on any thread. Its implementation must be thread-safe.
 */
- (BOOL)canProvideLabelsWithSearchResult:(nonnull YMKSearchResultItem *)searchResult;

@end

/**
 * Size of the icon
 */
@interface YMKSize : NSObject

/**
 * Width.
 */
@property (nonatomic, readonly) double width;

/**
 * Height.
 */
@property (nonatomic, readonly) double height;


+ (nonnull YMKSize *)sizeWithWidth:( double)width
                            height:( double)height;


@end
