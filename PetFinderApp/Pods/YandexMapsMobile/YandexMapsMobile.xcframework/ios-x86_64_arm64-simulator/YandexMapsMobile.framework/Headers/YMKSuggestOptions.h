#import <YandexMapsMobile/YMKPoint.h>

/**
 * Bitmask for requested suggest types.
 */
typedef NS_OPTIONS(NSUInteger, YMKSuggestType) {
    /**
     * Default value: server-defined types are returned.
     */
    YMKSuggestTypeUnspecified = 0,
    /**
     * Toponyms.
     */
    YMKSuggestTypeGeo = 1,
    /**
     * Companies.
     */
    YMKSuggestTypeBiz = 1 << 1,
    /**
     * Mass transit routes.
     */
    YMKSuggestTypeTransit = 1 << 2
};

/**
 * Struct to fine-tune suggest request.
 */
@interface YMKSuggestOptions : NSObject

/**
 * The suggest type can be one of YMKSuggestType values or their bitwise
 * 'OR' combination. If suggestType is not initialized, it means to use
 * server-defined types.
 */
@property (nonatomic, assign) YMKSuggestType suggestTypes;

/**
 * The server uses the user position to calculate the distance from the
 * user to suggest results.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, strong, nullable) YMKPoint *userPosition;

/**
 * Enable word-by-word suggestion items.
 */
@property (nonatomic, assign) BOOL suggestWords;

/**
 * Strictly limit the output and keep only objects that fall within the
 * window. The window is advisory in nature and doesn't impose strict
 * restrictions on search results, helping to select the most relevant
 * hints.
 */
@property (nonatomic, assign) BOOL strictBounds;

+ (nonnull YMKSuggestOptions *)suggestOptionsWithSuggestTypes:( YMKSuggestType)suggestTypes
                                                 userPosition:(nullable YMKPoint *)userPosition
                                                 suggestWords:( BOOL)suggestWords
                                                 strictBounds:( BOOL)strictBounds;


- (nonnull YMKSuggestOptions *)init;

@end
