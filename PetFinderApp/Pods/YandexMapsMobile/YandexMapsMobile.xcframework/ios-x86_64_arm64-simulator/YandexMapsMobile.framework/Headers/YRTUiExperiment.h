#import <Foundation/Foundation.h>

/**
 * Undocumented
 */
@interface YRTExperimentData : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSUInteger testId;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSUInteger userGroup;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSUInteger userBucket;


+ (nonnull YRTExperimentData *)experimentDataWithTestId:( NSUInteger)testId
                                              userGroup:( NSUInteger)userGroup
                                             userBucket:( NSUInteger)userBucket;


@end
