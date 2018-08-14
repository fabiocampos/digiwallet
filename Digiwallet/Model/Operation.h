//
//  Operation.h
//  Digiwallet
//
//  Created by Fabio Campos on 12/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>
#import "CoinPrice.h"
typedef enum OperationTypes : NSInteger {
    kCredit,
    kDebit
} OperationTypes;

@interface Operation : RLMObject
@property NSString *userEmail;
@property NSNumber<RLMFloat> *value;
@property NSNumber<RLMFloat> *usedValue;
@property NSString *type;
@property NSString *fromCoin;
@property NSString *toCoin;
@property NSDate *date;
+ (Operation*)createOperationForUser:(NSString*)userEmail fromCoin:(CoinPrice *)coin toCoin:(CoinPrice *)requestedCoin ofType:(TradeTypes)type;
+ (NSArray*)getUserOperations:(NSString*)userEmail;


@end
