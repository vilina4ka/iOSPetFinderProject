#import <Foundation/Foundation.h>

/**
 * Single category (also known as rubric) description.
 */
@interface YMKSearchCategory : NSObject

/**
 * Category name.
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 * Category class. Different categories can have the same class. For
 * example, "Bar", "Cafe" and "Restaurant" categories inhabit
 * "restaurants" category class.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *categoryClass;

/**
 * Additional non-structured data for the category.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *tags;


+ (nonnull YMKSearchCategory *)categoryWithName:(nonnull NSString *)name
                                  categoryClass:(nullable NSString *)categoryClass
                                           tags:(nonnull NSArray<NSString *> *)tags;


@end
