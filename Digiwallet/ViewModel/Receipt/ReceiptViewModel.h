//
//  ReceiptViewModel.h
//  Digiwallet
//
//  Created by Fabio Campos on 13/08/2018.
//  Copyright © 2018 green. All rights reserved.
//
#import <ReactiveObjC.h>
#import "CoinPrice.h"
#import "User.h"
#import "Operation.h"
@interface ReceiptViewModel : NSObject
@property (strong, nonatomic) User *currentUser;
@property NSArray<Operation *> *operations;
- (RACSignal *)getOperationReceipts;
@end
