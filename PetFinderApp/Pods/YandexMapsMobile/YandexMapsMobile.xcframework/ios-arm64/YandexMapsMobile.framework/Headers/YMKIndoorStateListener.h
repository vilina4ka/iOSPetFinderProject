#import <Foundation/Foundation.h>

@class YMKIndoorPlan;

/**
 * Allows to handle events related to Indoor state.
 */
@protocol YMKIndoorStateListener <NSObject>

/**
 * Notifies when user view focuses on a new plan (plan is NonNull).
 *
 * @param activePlan is valid until onActivePlanLeft call.
 */
- (void)onActivePlanFocusedWithActivePlan:(nonnull YMKIndoorPlan *)activePlan;

/**
 * Notifies when user view leaves focus on a current active plan.
 */
- (void)onActivePlanLeft;

/**
 * Notifies when the current active level is changed on the active plan.
 */
- (void)onActiveLevelChangedWithActiveLevelId:(nonnull NSString *)activeLevelId;

@end
