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
    }
    
    
    self.executeGetBitCoinPrice=
    [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                                return  [self executeGetBitcoinPriceSignal];
    }];
    return self;
}

- (RACSignal *)executeGetBitcoinPriceSignal {
    return [[[self.exchangeService getBitcoinPrice]
             doNext:^(BitcoinPrice *bitcoinPrice) {
                 self.error = nil;
                 self.bitcoinPrice = bitcoinPrice;
             }]
            doError:^(NSError * _Nonnull error) {
                NSLog(@"Falha ao recuperar valor BitCoin");
                self.error = error;
            }] ;
}


@end
