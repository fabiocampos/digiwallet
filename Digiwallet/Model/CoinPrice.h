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
    kBitcoin
} CoinTypes;

@interface CoinPrice : NSObject
@property (strong, nonatomic) NSNumber  *buyValue;
@property (strong, nonatomic) NSNumber  *sellValue;
@property enum CoinTypes type;
@end
