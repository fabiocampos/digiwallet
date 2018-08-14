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
     if(amount == nil || [amount floatValue] <= 0){
        errorMessage = @"O valor da operação precisa ser maior que R$0.00";
    }
    //@Todo validar saldo
    return errorMessage;
}
- (RACSignal *)performTradeOperation:(NSNumber*) amount{
    [self generateWallet:self.selectedWallet];
    float adjustedAmount;
    if(self.tradeType == kBuy){
        adjustedAmount = [amount floatValue] * [self.coinToTrade.buyValue floatValue];
    }else{
        adjustedAmount = [amount floatValue] * [self.coinToTrade.sellValue floatValue];
    }
    self.coinToTrade.tradeAmount = [NSNumber numberWithFloat:adjustedAmount];
   
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
            [self setPaymentValue: self.currentUser.balance];
            break;
        case 1:
            self.paymentWallet.type = kBitcoin;
            [self setPaymentValue: self.currentUser.bitcoinBalance];
            break;
        case 2:
            self.paymentWallet.type = kBrita;
            [self setPaymentValue: self.currentUser.britaBalance];
            break;
            
        default:
            break;
    }
}

-(void)setPaymentValue:(NSNumber *)paymentBalance{
    if(self.tradeType == kBuy){
        self.paymentWallet.buyValue = paymentBalance;
    }else{
        self.paymentWallet.sellValue = paymentBalance;
    }
}

@end
