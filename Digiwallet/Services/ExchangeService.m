//
//  ExchangeService.m
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ExchangeService.h"
#import "BitcoinApi.h"
@interface ExchangeService ()

@end

@implementation ExchangeService

- (instancetype)initWithApi:(BitcoinApi *)bitcoinApi {
    self = [super init];
    if (self ) {
        _bitcoinApi = bitcoinApi;
    }
    return self;
}

- (RACSignal *) getBitcoinPrice {
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [self.bitcoinApi getBitcoinCotationWithSuccess:^(BitcoinPrice *bitCointPrice) {
            NSLog(@"Recuperando cotação bitcoin %@", bitCointPrice.sellValue);
            [subscriber sendNext:bitCointPrice];
            [subscriber sendCompleted];
        } failure:^(NSError *err) {
            NSLog(@"Falha ao recuperar cotação bitcoin");
            [subscriber sendError:err];
            [subscriber sendCompleted];
        }];
    
        return nil;
    }];
}

@end
