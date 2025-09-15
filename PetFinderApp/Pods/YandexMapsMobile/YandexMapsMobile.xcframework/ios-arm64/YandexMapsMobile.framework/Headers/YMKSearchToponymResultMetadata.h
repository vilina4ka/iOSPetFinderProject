#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKPoint.h>

@class YMKSearchToponymResultMetadataResponseInfo;

/**
 * Search mode.
 */
typedef NS_ENUM(NSUInteger, YMKSearchToponymResultMetadataSearchMode) {
    /**
     * Search from text to toponym.
     */
    YMKSearchToponymResultMetadataSearchModeGeocode,
    /**
     * Search from coordinates to toponym.
     */
    YMKSearchToponymResultMetadataSearchModeReverse
};

/**
 * Common info for response from toponym search.
 */
@interface YMKSearchToponymResultMetadata : NSObject<YMKBaseMetadata>

/**
 * Approximate number of found objects.
 */
@property (nonatomic, readonly) NSInteger found;

/**
 * Additional response info.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKSearchToponymResultMetadataResponseInfo *responseInfo;

/**
 * The search coordinates given via 'll' or parsed from 'text' (only in
 * reverse mode).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKPoint *reversePoint;


+ (nonnull YMKSearchToponymResultMetadata *)toponymResultMetadataWithFound:( NSInteger)found
                                                              responseInfo:(nullable YMKSearchToponymResultMetadataResponseInfo *)responseInfo
                                                              reversePoint:(nullable YMKPoint *)reversePoint;


@end

/**
 * Additional response info.
 */
@interface YMKSearchToponymResultMetadataResponseInfo : NSObject

/**
 * Search mode.
 */
@property (nonatomic, readonly) YMKSearchToponymResultMetadataSearchMode mode;

/**
 * Search response accuracy.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *accuracy;


+ (nonnull YMKSearchToponymResultMetadataResponseInfo *)responseInfoWithMode:( YMKSearchToponymResultMetadataSearchMode)mode
                                                                    accuracy:(nullable NSNumber *)accuracy;


@end
