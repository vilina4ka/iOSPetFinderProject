#import <YandexMapsMobile/YMKMapWindow.h>
#import <YandexMapsMobile/YMKSearchLayer.h>
#import <YandexMapsMobile/YMKSearchManager.h>

@class YMKSearch;

/**
 * Undocumented
 */
@interface YMKSearch : NSObject

/**
 * Gets the search_layer object.
 */
- (nonnull YMKSearchLayer *)createSearchLayerWithMapWindow:(nonnull YMKMapWindow *)mapWindow;

/**
 * Creates a manager that allows to search for various geographical
 * objects using a variety of parameters.
 */
- (nonnull YMKSearchManager *)createSearchManagerWithSearchManagerType:(YMKSearchManagerType)searchManagerType;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end

/**
 * Undocumented
 */
@interface YMKSearchFactory : NSObject

+ (nonnull YMKSearch *)instance;

@end
