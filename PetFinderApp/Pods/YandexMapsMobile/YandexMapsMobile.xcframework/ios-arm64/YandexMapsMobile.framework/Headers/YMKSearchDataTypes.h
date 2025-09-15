#import <Foundation/Foundation.h>

/**
 * Bitmask for requested search types.
 */
typedef NS_OPTIONS(NSUInteger, YMKSearchType) {
    /**
     * Default value: all types requested.
     */
    YMKSearchTypeNone = 0,
    /**
     * Toponyms.
     */
    YMKSearchTypeGeo = 1,
    /**
     * Companies.
     */
    YMKSearchTypeBiz = 1 << 1
};

/**
 * Requested snippets bitmask.
 *
 * Snippets are additional pieces of information (possibly from
 * different services) which are not directly stored in object metadata
 * but may be requested separately based on client needs.
 *
 * Different snippets are applicable to different objects: some of the
 * snippets can be provided only for toponyms, some for businesses and
 * some for all object types.
 */
typedef NS_OPTIONS(NSUInteger, YMKSearchSnippet) {
    /**
     * Default value: no snippets requested.
     */
    YMKSearchSnippetNone = 0,
    /**
     * Related photos snippet (can be requested for a business or toponym).
     * See YMKSearchBusinessPhotoObjectMetadata.
     */
    YMKSearchSnippetPhotos = 1,
    /**
     * Information about ratings (can be requested for a business). See
     * YMKSearchBusinessRating1xObjectMetadata.
     */
    YMKSearchSnippetBusinessRating1x = 1 << 1,
    /**
     * Nearest panoramas to this point. See
     * YMKSearchPanoramasObjectMetadata.
     */
    YMKSearchSnippetPanoramas = 1 << 5
};
