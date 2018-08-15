//
//  Operation.m
//  Digiwallet
//
//  Created by Fabio Campos on 12/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "Operation.h"
#import "MoneyFormat.h"
@implementation Operation
+ (Operation*)createOperationForUser:(NSString*)userEmail fromCoin:(CoinPrice *)coin toCoin:(CoinPrice *)requestedCoin ofType:(TradeTypes)type{
    Operation *operation = [[Operation alloc] init];
    operation.userEmail = userEmail;
    operation.fromCoin = [MoneyFormat getCoinName:coin.type];
    operation.toCoin = [MoneyFormat getCoinName:requestedCoin.type];
    if(type == kBuy){
        operation.value = requestedCoin.tradeAmount;
        
        operation.usedValue = coin.tradeAmount;
        operation.type = @"Compra";
    }else{
        operation.value = requestedCoin.tradeAmount;
        operation.usedValue = coin.tradeAmount;
        operation.type = @"Venda";
    }
    operation.date = [NSDate date];
    
    
    return operation;
}
+ (NSArray*)getUserOperations:(NSString*)userEmail{
    NSString *query = [NSString stringWithFormat:@"userEmail == '%@'", userEmail];
   RLMResults<Operation *> *operations = [Operation objectsWhere:query];
    NSMutableArray *result = [NSMutableArray array];
    for (Operation *operation in operations) {
        [result addObject:operation];
    }
    return result;
}
@end
