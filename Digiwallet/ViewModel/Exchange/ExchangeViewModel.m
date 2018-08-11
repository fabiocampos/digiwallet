//
//  ExchangeViewModel.m
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ExchangeViewModel.h"

@interface ExchangeViewModel ()

@end

@implementation ExchangeViewModel 
    
- (instancetype)initWithServices:(ExchangeService *)exchangeService {
    self = [super init];
    if (self ) {
        _exchangeService = exchangeService;
        _coinPrices = [[NSMutableArray alloc] init];
    }
    
//    self.executeGetBitCoinPrice=
//    [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//                                return  [self executeGetBitcoinPriceSignal];
//    }];
//    
//    self.executeGetBritaPrice=
//    [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        return  [self executeGetBritaPriceSignal];
//    }];

    return self;
}

- (RACSignal *)executeGetBitcoinPriceSignal {
    return [[[self.exchangeService getBitcoinPrice]
             doNext:^(CoinPrice *bitcoinPrice) {
                 self.error = nil;
                 [self.coinPrices addObject:bitcoinPrice];
             }]
            doError:^(NSError * _Nonnull error) {
                NSLog(@"No price for bitcoin");
                self.error = error;
            }] ;
}

- (RACSignal *)executeGetBritaPriceSignal {
    return [[[self.exchangeService getBritaPrice]
             doNext:^(CoinPrice *britaPrice) {
                 self.error = nil;
                 [self.coinPrices addObject:britaPrice];
             }]
            doError:^(NSError * _Nonnull error) {
               NSLog(@"No price for brita");
                self.error = error;
            }] ;
}

@end
