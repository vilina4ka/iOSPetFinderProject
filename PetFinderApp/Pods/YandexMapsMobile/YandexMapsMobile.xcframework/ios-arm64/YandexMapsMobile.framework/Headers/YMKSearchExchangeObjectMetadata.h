#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKTaxiMoney.h>

/**
 * Single currency exchange prices.
 */
@interface YMKSearchCurrencyExchangeType : NSObject

/**
 * ISO-4217 currency name, for example "USD" or "RUB" or "EUR".
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *name;

/**
 * Buy rate.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKTaxiMoney *buy;

/**
 * Sell rate.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKTaxiMoney *sell;


+ (nonnull YMKSearchCurrencyExchangeType *)currencyExchangeTypeWithName:(nullable NSString *)name
                                                                    buy:(nullable YMKTaxiMoney *)buy
                                                                   sell:(nullable YMKTaxiMoney *)sell;


@end

/**
 * Currency exchange snippet.
 */
@interface YMKSearchCurrencyExchangeMetadata : NSObject<YMKBaseMetadata>

/**
 * Available currency exchange rates.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchCurrencyExchangeType *> *currencies;


+ (nonnull YMKSearchCurrencyExchangeMetadata *)currencyExchangeMetadataWithCurrencies:(nonnull NSArray<YMKSearchCurrencyExchangeType *> *)currencies;


@end
