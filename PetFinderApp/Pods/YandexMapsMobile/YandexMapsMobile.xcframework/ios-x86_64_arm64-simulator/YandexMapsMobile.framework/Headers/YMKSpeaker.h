#import <YandexMapsMobile/YMKAnnotationLang.h>
#import <YandexMapsMobile/YMKPhraseToken.h>

@class YMKLocalizedPhrase;

/**
 * Undocumented
 */
@protocol YMKSpeaker <NSObject>

/**
 * Stops all speech and forgets all previously scheduled phrases.
 */
- (void)reset;

/**
 * Pronounces the phrase, interrupting the one being spoken now, if
 * neccessary.
 */
- (void)sayWithPhrase:(nonnull YMKLocalizedPhrase *)phrase;

/**
 * Returns the phrase duration (how many seconds it takes to pronounce
 * it).
 */
- (double)durationWithPhrase:(nonnull YMKLocalizedPhrase *)phrase;

@end

/**
 * Undocumented
 */
@interface YMKLocalizedPhrase : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSArray<NSNumber *> *tokens;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSString *text;

/**
 * Undocumented
 */
@property (nonatomic, readonly) YMKAnnotationLanguage language;


+ (nonnull YMKLocalizedPhrase *)localizedPhraseWithTokens:(nonnull NSArray<NSNumber *> *)tokens
                                                     text:(nonnull NSString *)text
                                                 language:( YMKAnnotationLanguage)language;


@end
