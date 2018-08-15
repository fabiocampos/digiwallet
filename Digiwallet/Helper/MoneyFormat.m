//
//  MoneyFormat.m
//  Digiwallet
//
//  Created by Fabio Campos on 12/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "MoneyFormat.h"

@implementation MoneyFormat

+ (NSString*)formatMoney:(NSNumber*)moneyValue withMask:(NSString*)mask{
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [numberFormatter setCurrencyCode:mask];
        [numberFormatter setMaximumFractionDigits:3];
        [numberFormatter setRoundingMode:NSNumberFormatterRoundUp];
        NSString *numberAsString = [numberFormatter stringFromNumber:[NSDecimalNumber numberWithDouble:[moneyValue doubleValue]]];

        return numberAsString;
}

+ (NSNumber*)truncateMoney:(NSNumber*)moneyValue{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:3];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundUp];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSDecimalNumber numberWithDouble:[moneyValue doubleValue]]];
   // NSDecimalNumber *cow = [NSDecimalNumber decimalNumberWithString:foo];
    return [numberFormatter numberFromString:numberAsString];
}

+ (UIImage*)getCoinImage:(CoinPrice*)coinPrice{
    NSString *moneyPicture;
    switch (coinPrice.type) {
        case kBitcoin:
            moneyPicture = @"bitcoin_big";
            break;
        case kBrita:
            moneyPicture = @"dime_big";
            break;
            
        default:
            moneyPicture = @"dime_big";
            break;
    }
    return [UIImage imageNamed:moneyPicture];
}

+ (NSString*)getCoinMask:(CoinTypes)coinType{
    NSString *mask;
    switch (coinType) {
        case kBitcoin:
            mask = @"BTC";
            break;
        case kBrita:
            mask = @"X$";
            break;
            
        default:
            mask = @"R$";
            break;
    }
    return mask;
}

+ (NSString*)getCoinMaskByName:(NSString*)coinName{
    NSString *mask;
    if([coinName isEqualToString:@"Brita"]){
        mask = @"X$";
    }else if([coinName isEqualToString:@"Bitcoin"]){
        mask = @"BTC";
    }else{
        mask = @"R$";
    }
    return mask;
}

+ (NSString*)getCoinName:(CoinTypes)coinType{
    NSString *name;
    switch (coinType) {
        case kBitcoin:
            name = @"Bitcoin";
            break;
        case kBrita:
            name = @"Brita";
            break;
            
        default:
            name = @"Reais";
            break;
    }
    return name;
}

@end
