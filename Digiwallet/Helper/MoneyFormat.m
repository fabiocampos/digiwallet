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
        NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[moneyValue floatValue]]];
        return numberAsString;
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

@end
