//
//  TradeViewModel.m
//  Digiwallet
//
//  Created by Fabio Campos on 12/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "TradeViewModel.h"


@implementation TradeViewModel
- (instancetype)initWithServices:(ExchangeService *)exchangeService andUser:(User *)currentUser toTrade:(CoinPrice *)coin{
    self = [super init];
    if (self ) {
        _exchangeService = exchangeService;
        _currentUser = currentUser;
        _coinToTrade = coin;
        _availableCoins = @[@"Reais", @"Bitcoin", @"Britas"];
    }
    return self;
}
- (NSString *)validateAmount:(NSNumber*) amount{
    NSString *errorMessage;
     if(amount == nil || [amount doubleValue] <= 0){
        errorMessage = @"O valor da operação precisa ser maior que R$0.00";
    }

    return errorMessage;
}
- (RACSignal *)performTradeOperation:(NSNumber*) amount{
    [self generateWallet:self.selectedWallet];
    self.coinToTrade.tradeAmount = [[NSDecimalNumber alloc] initWithDouble:[amount doubleValue]];
    return [ self.exchangeService performTradeOperation:self.paymentWallet forCoin:self.coinToTrade ofType:self.tradeType forUser:self.currentUser];
}

-(NSString*)getTitleForRow:(NSInteger)row{
    return self.availableCoins[row];
}

-(void)generateWallet:(NSInteger)row{
    self.paymentWallet = [[CoinPrice alloc] init];
    switch (row) {
        case 0:
            self.paymentWallet.type = kBRL;
            break;
        case 1:
            self.paymentWallet.type = kBitcoin;
            break;
        case 2:
            self.paymentWallet.type = kBrita;
            break;
            
        default:
            break;
    }
    self.paymentWallet.sellValue =  [[NSDecimalNumber alloc] initWithInt:1];
    self.paymentWallet.buyValue = [[NSDecimalNumber alloc] initWithInt:1];
    self.paymentWallet.tradeAmount = [[NSDecimalNumber alloc] initWithInt:1];
}

@end
