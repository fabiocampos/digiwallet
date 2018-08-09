//
//  ExchangeService.m
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ExchangeService.h"
#import "BitcoinApi.h"
@implementation ExchangeService

- (RACSignal *) getBitcoinPrice {
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        
        [[[BitcoinApi alloc] init] getBitcoinCotationWithSuccess:^(BitcoinPrice *bitCointPrice) {
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
