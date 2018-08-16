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
     return [RACSignal createSignal:^RACDisposable *(id subscriber) {
         if(type == kSell &&
            ![self canPerformSellOperation:user forRequiredCoin:requestedCoin withAmount:[fromCoin.tradeAmount doubleValue]])
         {
             [subscriber sendError:[NSError errorWithDomain:FSDigiwalletDomain code:FSNotEnoughtMoney userInfo:nil] ];
             [subscriber sendCompleted];
             
             return nil;
         }
    [[self getLatestPriceFor:fromCoin] subscribeNext:^(CoinPrice *updatedFromCoin) {
        [[self getLatestPriceFor:requestedCoin] subscribeNext:^(CoinPrice *updatedRequestedCoin) {
            updatedFromCoin.tradeAmount = fromCoin.tradeAmount;
            updatedRequestedCoin.tradeAmount = requestedCoin.tradeAmount;
            [self setTradeAmountOf:updatedFromCoin and:updatedRequestedCoin for:type];
            
            [[self updateWalletOfUser:user from:updatedFromCoin to:updatedRequestedCoin ofType:type] subscribeNext:^(id  _Nullable x) {
                [subscriber sendNext:x];
                [subscriber sendCompleted];
            } error:^(NSError * _Nullable error) {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
        }];
        
    } error:^(NSError * _Nullable error) {
        [subscriber sendError:error];
        [subscriber sendCompleted];
    }];
         return nil;
    }];
}

- (RACSignal *) getLatestPriceFor:(CoinPrice *)coin{
    switch (coin.type) {
        case kBrita:
            return [self getBritaPrice];
            break;
        case kBitcoin:
            return [self getBitcoinPrice];
            break;
        default:
            return [RACSignal createSignal:^RACDisposable *(id subscriber) {
                 [subscriber sendNext:coin];
                 [subscriber sendCompleted];
                return nil;
             }];
            break;
    }
}
- (void)setTradeAmountOf:(CoinPrice*)fromCoin and:(CoinPrice*)toCoin for:(TradeTypes)type{
    double fromTradeAmount;
    if(type == kSell){
        fromTradeAmount =  [toCoin.tradeAmount doubleValue] * ([toCoin.sellValue doubleValue] / [fromCoin.buyValue doubleValue]);
        fromCoin.tradeAmount = [[NSDecimalNumber alloc] initWithDouble:fromTradeAmount];
      }else{
        toCoin.tradeAmount =  toCoin.tradeAmount;
        fromTradeAmount = [toCoin.tradeAmount doubleValue] * ([toCoin.buyValue doubleValue] / [fromCoin.sellValue doubleValue]);
        fromCoin.tradeAmount = [[NSDecimalNumber alloc] initWithDouble:fromTradeAmount];
    }
}

- (RACSignal *) updateWalletOfUser:(User *)user from:(CoinPrice *)fromCoin to:(CoinPrice *)requestedCoin ofType:(TradeTypes)type{
   return [RACSignal createSignal:^RACDisposable *(id subscriber) {
       
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
             [realm commitWriteTransaction];
            [subscriber sendNext:operation];
            [subscriber sendCompleted];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
             [realm cancelWriteTransaction];
        }];
    } error:^(NSError * _Nullable error) {
        [subscriber sendError:error];
        [subscriber sendCompleted];
        [realm cancelWriteTransaction];
    }];
       }];
       
       return nil;
   }];
    
}

- (RACSignal *) adjustBalanceOfUser:(User *)user using:(CoinPrice *)coin operationOfType:(TradeTypes)type adjusting:(OperationTypes)adjustmentType{
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
    NSDecimalNumber *balanceToUpdate = coin.tradeAmount;
    if(adjustmentType == kDebit){
        balanceToUpdate = [balanceToUpdate decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithInt:-1]];
    }
    if(coin.type == kBRL){
        NSDecimalNumber *balance = [balanceToUpdate decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:[user.balance doubleValue]]];
         if(type == kSell || [self canPerformBuyOperation:[balance floatValue]]){
             user.balance = balance;
        }else{
            NSLog(@"Not enougth brl");
            [subscriber sendError:[NSError errorWithDomain:FSDigiwalletDomain code:FSNotEnoughtMoney userInfo:nil] ];
            [subscriber sendCompleted];
        }
     }else if(coin.type == kBrita){
         NSDecimalNumber *balance  = [balanceToUpdate decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:[user.britaBalance doubleValue]]];
         if(type == kSell || [self canPerformBuyOperation:[balance floatValue]]){
             user.britaBalance = balance;
         }else{
             NSLog(@"Not enougth britas");
             [subscriber sendError:[NSError errorWithDomain:FSDigiwalletDomain code:FSNotEnoughtMoney userInfo:nil] ];
             [subscriber sendCompleted];
         }
    }else{
        NSDecimalNumber *balance  = [balanceToUpdate decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:[user.bitcoinBalance doubleValue]]];
        if(type == kSell || [self canPerformBuyOperation:[balance floatValue]]){
            user.bitcoinBalance = balance;
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

-(bool)canPerformSellOperation:(User*)user forRequiredCoin:(CoinPrice*)requiredCoin withAmount:(double)amount{
    double userBalance;
    double requiredAmount = [requiredCoin.tradeAmount doubleValue] * amount;
    
    switch (requiredCoin.type) {
        case kBrita:
            userBalance = [user.britaBalance doubleValue];
            break;
        case kBitcoin:
            userBalance = [user.bitcoinBalance doubleValue];
            break;
        default:
            userBalance = [user.balance doubleValue];
    }
    if(requiredAmount > userBalance){
        return NO;
    }
    return YES;
}

@end
