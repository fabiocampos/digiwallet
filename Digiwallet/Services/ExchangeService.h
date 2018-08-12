//
//  ExchangeService.h
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "BitcoinApi.h"
#import "BritaApi.h"
#import "User.h"
@interface ExchangeService : NSObject
@property (strong, nonatomic) BitcoinApi *bitcoinApi;
@property (strong, nonatomic) BritaApi *britaApi;
- (instancetype)initWithBitcoinApi:(BitcoinApi *)bitcoinApi andBritaApi:(BritaApi *)britaApi;
- (RACSignal *) getBitcoinPrice;
- (RACSignal *) getBritaPrice;
- (RACSignal *) buyBitcoinforUser:(User *)user;
- (RACSignal *) sellCoin:(CoinPrice*)coinPrice forUser:(User *)user;
@end

