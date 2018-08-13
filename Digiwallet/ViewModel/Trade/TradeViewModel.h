//
//  TradeViewModel.h
//  Digiwallet
//
//  Created by Fabio Campos on 12/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "CoinPrice.h"
#import "ExchangeService.h"
@interface TradeViewModel : NSObject

@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) CoinPrice *selectedCoin;
@property (strong, nonatomic) CoinPrice *coinToTrade;
@property (strong, nonatomic) ExchangeService *exchangeService;
@property (strong, nonatomic) User *currentUser;
- (instancetype)initWithServices:(ExchangeService *)exchangeService andUser:(User *)currentUser toTrade:(CoinPrice *)coin;
@end
