//
//  ExchangeService.m
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ExchangeService.h"
#import "FSError.h"
#import "Operation.h"
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


- (RACSignal *) performTradeOperation:(CoinPrice *)fromCoin forCoin:(CoinPrice *)requestedCoin ofType:(TradeTypes)type forUser:(User *)user{
    return [self updateWalletOfUser:(User *)user from:(CoinPrice *)fromCoin to:(CoinPrice *)requestedCoin ofType:type];
}


- (RACSignal *) updateWalletOfUser:(User *)user from:(CoinPrice *)fromCoin to:(CoinPrice *)requestedCoin ofType:(TradeTypes)type{
   return [RACSignal createSignal:^RACDisposable *(id subscriber) {
    fromCoin.tradeAmount = requestedCoin.tradeAmount;
    if(type == kSell){
        fromCoin.buyValue = fromCoin.tradeAmount;
    }else{
       fromCoin.sellValue = fromCoin.tradeAmount;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        
        [[self adjustBalanceOfUser:user using:fromCoin operationOfType:type adjusting: type == kSell ? kCredit:kDebit ] subscribeNext:^(id  _Nullable x) {
        [[self adjustBalanceOfUser:user using:requestedCoin operationOfType:type adjusting: type == kSell ? kDebit:kCredit ] subscribeNext:^(id  _Nullable x) {
            Operation *operation;
            if( type == kSell){
                 operation = [Operation createOperationForUser:user.email fromCoin:requestedCoin toCoin:fromCoin ofType:type];
            }else{
                 operation = [Operation createOperationForUser:user.email fromCoin:fromCoin toCoin:requestedCoin ofType:type];
            }
            [realm addObject:operation];
            [subscriber sendNext:operation];
            [subscriber sendCompleted];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
        }];
    } error:^(NSError * _Nullable error) {
        [subscriber sendError:error];
        [subscriber sendCompleted];
    }];
       }];
       
       return nil;
   }];
    
}

- (RACSignal *) adjustBalanceOfUser:(User *)user using:(CoinPrice *)coin operationOfType:(TradeTypes)type adjusting:(OperationTypes)adjustmentType{
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
    float balanceToUpdate = [coin.tradeAmount floatValue];
//    if(type == kSell){
//        balanceToUpdate = [coin.sellValue floatValue];
//    }else{
//        balanceToUpdate = [coin.buyValue floatValue];
//    }
    if(adjustmentType == kDebit){
        balanceToUpdate = -balanceToUpdate;
    }
    if(coin.type == kBRL){
        float brlBalance = [user.balance floatValue] + balanceToUpdate;
        if(type == kSell || [self canPerformBuyOperation:brlBalance]){
            user.balance =  [NSNumber numberWithFloat:brlBalance];
        }else{
            NSLog(@"Not enougth brl");
            [subscriber sendError:[NSError errorWithDomain:FSDigiwalletDomain code:FSNotEnoughtMoney userInfo:nil] ];
            [subscriber sendCompleted];
        }
     }else if(coin.type == kBrita){
         float britaBalance = [user.britaBalance floatValue] + balanceToUpdate;
         if(type == kSell || [self canPerformBuyOperation:britaBalance]){
             user.britaBalance =  [NSNumber numberWithFloat:britaBalance];
         }else{
             NSLog(@"Not enougth britas");
             [subscriber sendError:[NSError errorWithDomain:FSDigiwalletDomain code:FSNotEnoughtMoney userInfo:nil] ];
             [subscriber sendCompleted];
         }
    }else{
        float bitCoinBalance = [user.bitcoinBalance floatValue] + balanceToUpdate;
        if(type == kSell || [self canPerformBuyOperation:bitCoinBalance]){
         user.bitcoinBalance =  [NSNumber numberWithFloat:bitCoinBalance];
        }else{
            NSLog(@"Not enougth bitcoins");
            [subscriber sendError:[NSError errorWithDomain:FSDigiwalletDomain code:FSNotEnoughtMoney userInfo:nil] ];
            [subscriber sendCompleted];
        }
    }
        [subscriber sendNext:@"Sucesso"];
        [subscriber sendCompleted];
        return nil;
}];
}

-(bool)canPerformBuyOperation:(float)balance{
    if(balance < 0){
        return NO;
    }
    return YES;
}

@end
