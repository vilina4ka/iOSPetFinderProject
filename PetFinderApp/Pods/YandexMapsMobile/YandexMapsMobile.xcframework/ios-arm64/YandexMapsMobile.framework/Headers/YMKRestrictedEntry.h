#import <Foundation/Foundation.h>

/**
 * Defines a point on a pedestrian path.
 */
@interface YMKRestrictedEntry : NSObject

/**
 * Index of the point in the section geometry.
 */
@property (nonatomic, readonly) NSUInteger position;


+ (nonnull YMKRestrictedEntry *)restrictedEntryWithPosition:( NSUInteger)position;


@end

/**
 * Defines a vector of points on a pedestrian path.
 */
@interface YMKRestrictedEntriesContainer : NSObject

/**
 * Vector of points on a pedestrian path.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKRestrictedEntry *> *entries;


+ (nonnull YMKRestrictedEntriesContainer *)restrictedEntriesContainerWithEntries:(nonnull NSArray<YMKRestrictedEntry *> *)entries;


@end
