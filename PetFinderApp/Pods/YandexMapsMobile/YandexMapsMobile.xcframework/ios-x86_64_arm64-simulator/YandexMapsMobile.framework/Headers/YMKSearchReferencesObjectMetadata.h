#import <YandexMapsMobile/YMKBaseMetadata.h>

/**
 * The type of reference.
 */
@interface YMKSearchReferenceType : NSObject

/**
 * Reference ID.
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * Reference scope.
 */
@property (nonatomic, readonly, nonnull) NSString *scope;


+ (nonnull YMKSearchReferenceType *)referenceTypeWithId:(nonnull NSString *)id
                                                  scope:(nonnull NSString *)scope;


@end

/**
 * Reference metadata information.
 */
@interface YMKSearchReferencesObjectMetadata : NSObject<YMKBaseMetadata>

/**
 * The  list of references.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchReferenceType *> *references;


+ (nonnull YMKSearchReferencesObjectMetadata *)referencesObjectMetadataWithReferences:(nonnull NSArray<YMKSearchReferenceType *> *)references;


@end
