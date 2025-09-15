#import <YandexMapsMobile/YMKBaseMetadata.h>

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKGeoObjectInspectionMetadataObjectType) {
    /**
     * Undocumented
     */
    YMKGeoObjectInspectionMetadataObjectTypePoint,
    /**
     * Undocumented
     */
    YMKGeoObjectInspectionMetadataObjectTypePolyline,
    /**
     * Undocumented
     */
    YMKGeoObjectInspectionMetadataObjectTypePolygon,
    /**
     * Undocumented
     */
    YMKGeoObjectInspectionMetadataObjectTypeCircle
};

/**
 * Metadata type added to all objects returned by Map.visibleObjects
 */
@interface YMKGeoObjectInspectionMetadata : NSObject<YMKBaseMetadata>

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSString *layerId;

/**
 * Undocumented
 */
@property (nonatomic, readonly) YMKGeoObjectInspectionMetadataObjectType objectType;


+ (nonnull YMKGeoObjectInspectionMetadata *)geoObjectInspectionMetadataWithLayerId:(nonnull NSString *)layerId
                                                                        objectType:( YMKGeoObjectInspectionMetadataObjectType)objectType;


@end
