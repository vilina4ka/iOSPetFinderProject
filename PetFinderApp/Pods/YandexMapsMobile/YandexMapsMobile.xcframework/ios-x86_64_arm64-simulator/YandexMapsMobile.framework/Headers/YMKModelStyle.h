#import <Foundation/Foundation.h>

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKModelStyleUnitType) {
    /**
     * The model is given in units. The size of a unit is equal to the size
     * of a pixel at the current zoom level when the camera position's tilt
     * is equal to 0 and the scale factor is equal to 1.
     */
    YMKModelStyleUnitTypeUnit,
    /**
     * Scale model proportionally to fit into 1x1x1 box.
     */
    YMKModelStyleUnitTypeNormalized __attribute__((deprecated("Use UnitType.Unit instead."))),
    /**
     * The model is given in meters.
     */
    YMKModelStyleUnitTypeMeter
};

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKModelStyleRenderMode) {
    /**
     * Model should be rendered with buildings from ground layer.
     */
    YMKModelStyleRenderModeBuilding,
    /**
     * Model should be rendered within separate sublayer.
     */
    YMKModelStyleRenderModeUserModel
};

/**
 * The style of the model.
 */
@interface YMKModelStyle : NSObject

/**
 * Scale the model by this value.
 */
@property (nonatomic, assign) float scale;

/**
 * Unit type of the model.
 */
@property (nonatomic, assign) YMKModelStyleUnitType unitType;

/**
 * Defines should it be rendered with buildings from ground layer.
 */
@property (nonatomic, assign) YMKModelStyleRenderMode renderMode;

/**
 * Name of variant to render model with. See KHR_materials_variants gltf
 * extension. This works only for glTF models.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSString *variantName;

+ (nonnull YMKModelStyle *)modelStyleWithScale:( float)scale
                                      unitType:( YMKModelStyleUnitType)unitType
                                    renderMode:( YMKModelStyleRenderMode)renderMode
                                   variantName:(nullable NSString *)variantName;


- (nonnull YMKModelStyle *)init;

@end
