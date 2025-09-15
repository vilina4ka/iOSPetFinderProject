#import <Foundation/Foundation.h>

@class YMKSpannableStringSpan;

/**
 * A string that supports spans in it.
 */
@interface YMKSpannableString : NSObject

/**
 * The text of the spannable string.
 */
@property (nonatomic, readonly, nonnull) NSString *text;

/**
 * The spans in stored text.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSpannableStringSpan *> *spans;


+ (nonnull YMKSpannableString *)spannableStringWithText:(nonnull NSString *)text
                                                  spans:(nonnull NSArray<YMKSpannableStringSpan *> *)spans;


@end

/**
 * A span of text in the SpannableString.
 */
@interface YMKSpannableStringSpan : NSObject

/**
 * The index of the beginning symbol of the span.
 */
@property (nonatomic, readonly) NSInteger begin;

/**
 * The index of the ending symbol of the span.
 */
@property (nonatomic, readonly) NSInteger end;


+ (nonnull YMKSpannableStringSpan *)spanWithBegin:( NSInteger)begin
                                              end:( NSInteger)end;


@end
