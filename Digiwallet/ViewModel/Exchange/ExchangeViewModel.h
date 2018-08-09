//
//  ExchangeViewModel.h
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <ReactiveObjC.h>
#import "BitcoinPrice.h"
#import "ExchangeService.h"
@interface ExchangeViewModel : NSObject

@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) RACCommand *executeGetBitCoinPrice;
@property (strong, nonatomic) BitcoinPrice *bitcoinPrice;
@property (strong, nonatomic) ExchangeService *exchangeService;
- (instancetype)initWithServices:(ExchangeService *)exchangeService;
@end
