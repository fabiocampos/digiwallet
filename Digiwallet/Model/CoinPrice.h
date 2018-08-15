//
//  CoinPrice.h
//  Digiwallet
//
//  Created by Fabio Campos on 11/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum CoinTypes : NSUInteger {
    kBrita,
    kBitcoin,
    kBRL
} CoinTypes;

typedef enum TradeTypes : NSUInteger {
    kBuy,
    kSell
} TradeTypes;

@interface CoinPrice : NSObject
@property (strong, nonatomic) NSDecimalNumber  *buyValue;
@property (strong, nonatomic) NSDecimalNumber  *sellValue;
@property (strong, nonatomic) NSDecimalNumber  *tradeAmount;
@property enum CoinTypes type;
@property (strong, nonatomic) NSString  *name;
@end
