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
@interface ExchangeService : NSObject
@property (strong, nonatomic) BitcoinApi *bitcoinApi;
- (instancetype)initWithApi:(BitcoinApi *)bitcoinApi;
- (RACSignal *) getBitcoinPrice;
@end

