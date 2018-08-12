//
//  ExchangeViewModel.h
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <ReactiveObjC.h>
#import "CoinPrice.h"
#import "ExchangeService.h"
@interface ExchangeViewModel : NSObject

@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) NSMutableArray<CoinPrice *> *coinPrices;
@property (strong, nonatomic) ExchangeService *exchangeService;
@property (strong, nonatomic) User *currentUser;
- (instancetype)initWithServices:(ExchangeService *)exchangeService;
- (RACSignal *)executeGetBitcoinPriceSignal;
- (RACSignal *)executeGetBritaPriceSignal;
- (CoinPrice *)getDisplayableUserCoin;
- (void)cycleUserCoin;
@end
