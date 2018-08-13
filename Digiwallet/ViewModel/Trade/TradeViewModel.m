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
    }
    return self;
}

@end
