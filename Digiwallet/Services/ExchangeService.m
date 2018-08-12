//
//  ExchangeService.m
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ExchangeService.h"
#import "FSError.h"
@interface ExchangeService ()

@end

@implementation ExchangeService

- (instancetype)initWithBitcoinApi:(BitcoinApi *)bitcoinApi andBritaApi:(BritaApi *)britaApi{
    self = [super init];
    if (self ) {
        _bitcoinApi = bitcoinApi;
        _britaApi = britaApi;
    }
    return self;
}

- (RACSignal *) getBitcoinPrice {
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [self.bitcoinApi getBitcoinCotationWithSuccess:^(CoinPrice *bitcoinPrice) {
            NSLog(@"Bitcoin sell value %@", bitcoinPrice.sellValue);
            [subscriber sendNext:bitcoinPrice];
            [subscriber sendCompleted];
        } failure:^(NSError *err) {
            NSLog(@"Bitcoin value recover error");
            [subscriber sendError:err];
            [subscriber sendCompleted];
        }];
    
        return nil;
    }];
}

- (RACSignal *) getBritaPrice {
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [self.britaApi getBritaCotationWithSuccess:^(CoinPrice *britaPrice) {
            NSLog(@"Brita sell value %@", britaPrice.sellValue);
            [subscriber sendNext:britaPrice];
            [subscriber sendCompleted];
        } failure:^(NSError *err) {
            NSLog(@"Brita value recover error");
            [subscriber sendError:err];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

- (RACSignal *) buyBitcoinforUser:(User *)user {
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        return nil;
    }];
}
- (RACSignal *) sellCoin:(CoinPrice*)coinPrice forUser:(User *)user{
        switch (coinPrice.type) {
            case kBrita:
                return [self sellBrita:coinPrice forUser:user];
                break;
                
            default:
                break;
        }
        return nil;
}

- (RACSignal *) sellBrita:(CoinPrice*)coinPrice forUser:(User *)user {
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        NSNumber *britaBalance = user.britaBalance;
        if([coinPrice sellValue] < britaBalance){
            NSLog(@"Not enougth britas");
            [subscriber sendError:[NSError errorWithDomain:FSDigiwalletDomain code:FSNotEnoughtMoney userInfo:nil] ];
            [subscriber sendCompleted];
        }else{
            [self.britaApi getBritaCotationWithSuccess:^(CoinPrice *britaPrice) {
                float brlBalance = [britaPrice.sellValue floatValue] + [user.balance floatValue] ;
              //  user.balance = [NSNumber numberWithFloat:brlBalance]
                NSLog(@"New user balance %.05f", brlBalance);
                [subscriber sendNext:user.balance];
                [subscriber sendCompleted];
            } failure:^(NSError *err) {
                NSLog(@"Brita value recover error");
                [subscriber sendError:[NSError errorWithDomain:FSDigiwalletDomain code:FSBrokerNotAvailable userInfo:nil] ];
                [subscriber sendCompleted];
            }];
        }
        return nil;
    }];
}
@end
