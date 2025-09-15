#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YMKSearchDataTypes.h>
#import <YandexMapsMobile/YMKSearchFilterCollection.h>

/**
 * Struct to fine-tune search request.
 */
@interface YMKSearchOptions : NSObject

/**
 * The search type can be one of the YMKSearchType values or their
 * bitwise 'OR' combination. If searchType is not initialized, it means
 * to search in all the sources.
 */
@property (nonatomic, assign) YMKSearchType searchTypes;

/**
 * Maximum number of search results per page.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *resultPageSize;

/**
 * Snippets that will be requested. The value should be one of
 * YMKSearchSnippet, or their bitwise 'OR' combination.
 */
@property (nonatomic, assign) YMKSearchSnippet snippets;

/**
 * The server uses the user position to calculate the distance from the
 * user to search results.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, strong, nullable) YMKPoint *userPosition;

/**
 * String that sets an identifier for the request source.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSString *origin;

/**
 * Adds the geometry to the server response.
 */
@property (nonatomic, assign) BOOL geometry;

/**
 * Force disable correction of spelling mistakes.
 */
@property (nonatomic, assign) BOOL disableSpellingCorrection;

/**
 * Filter set that will be requested. Please note that the full set of
 * filters that can be applied can only be obtained after the primary
 * request. If you pass an invalid filter to the primary request (for
 * example, "pharmacy with swimming pool"), the behavior is undefined.
 * That is the search can either ignore an invalid filter or return an
 * empty response.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, strong, nullable) YMKSearchFilterCollection *filters;

+ (nonnull YMKSearchOptions *)searchOptionsWithSearchTypes:( YMKSearchType)searchTypes
                                            resultPageSize:(nullable NSNumber *)resultPageSize
                                                  snippets:( YMKSearchSnippet)snippets
                                              userPosition:(nullable YMKPoint *)userPosition
                                                    origin:(nullable NSString *)origin
                                                  geometry:( BOOL)geometry
                                 disableSpellingCorrection:( BOOL)disableSpellingCorrection
                                                   filters:(nullable YMKSearchFilterCollection *)filters;


- (nonnull YMKSearchOptions *)init;

@end
