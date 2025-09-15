#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YRTKeyValuePair.h>

/**
 * Separate subtitle of a certain type.
 */
@interface YMKSearchSubtitleItem : NSObject

/**
 * Subtitle type. For example, "exchange".
 */
@property (nonatomic, readonly, nonnull) NSString *type;

/**
 * Short summary text. For example, "USD 57.69/57.3".
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *text;

/**
 * Detailed subtitle info. For example, [ {"key": "currency", "value":
 * "USD"}, {"key": "buy", "value": "57.3"}, {"key": "sell", "value":
 * "57.69"} ].
 */
@property (nonatomic, readonly, nonnull) NSArray<YRTKeyValuePair *> *properties;


+ (nonnull YMKSearchSubtitleItem *)subtitleItemWithType:(nonnull NSString *)type
                                                   text:(nullable NSString *)text
                                             properties:(nonnull NSArray<YRTKeyValuePair *> *)properties;


@end

/**
 * Subtitle snippet.
 */
@interface YMKSearchSubtitleMetadata : NSObject<YMKBaseMetadata>

/**
 * List of subtitles.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchSubtitleItem *> *subtitleItems;

/**
 * List of subtitles to be displayed in SERP.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchSubtitleItem *> *serpSubtitleItems;


+ (nonnull YMKSearchSubtitleMetadata *)subtitleMetadataWithSubtitleItems:(nonnull NSArray<YMKSearchSubtitleItem *> *)subtitleItems
                                                       serpSubtitleItems:(nonnull NSArray<YMKSearchSubtitleItem *> *)serpSubtitleItems;


@end
