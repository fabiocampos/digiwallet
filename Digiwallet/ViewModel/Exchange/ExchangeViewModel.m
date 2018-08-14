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
int displayableUserCoinIndex = 0;
- (instancetype)initWithServices:(ExchangeService *)exchangeService {
    self = [super init];
    if (self ) {
        _exchangeService = exchangeService;
        _coinPrices = [[NSMutableArray alloc] init];
    }
    return self;
}

- (RACSignal *)executeGetBitcoinPriceSignal{
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

- (CoinPrice *)getDisplayableUserCoin{
     CoinPrice *coin = [[CoinPrice alloc] init];
    switch (displayableUserCoinIndex) {
        case 0:
            coin.sellValue = _currentUser.balance;
            coin.type = kBRL;
            coin.name = @"Reais";
            break;
        case 1:
            coin.sellValue = _currentUser.britaBalance;
            coin.type = kBrita;
            coin.name = @"Brita";
            break;
        case 2:
            coin.sellValue = _currentUser.bitcoinBalance;
            coin.type = kBitcoin;
            coin.name = @"Bitcoin";
            break;
        default:
            break;
    }
    return coin;
}
- (void)cycleUserCoin {
    if(displayableUserCoinIndex < 2){
        displayableUserCoinIndex++;
    }else{
        displayableUserCoinIndex = 0;
    }
}
@end
