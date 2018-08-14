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
@property (strong, nonatomic) NSNumber  *buyValue;
@property (strong, nonatomic) NSNumber  *sellValue;
@property (strong, nonatomic) NSNumber  *tradeAmount;
@property enum CoinTypes type;
@property (strong, nonatomic) NSString  *name;
@end
