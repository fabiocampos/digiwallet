//
//  ReceiptViewModel.m
//  Digiwallet
//
//  Created by Fabio Campos on 13/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ReceiptViewModel.h"

@implementation ReceiptViewModel
- (RACSignal *)getOperationReceipts{
      return [RACSignal createSignal:^RACDisposable *(id subscriber) {
          NSArray *results = [Operation getUserOperations:self.currentUser.email];
          self.operations = results;
          [subscriber sendNext:results];
          [subscriber sendCompleted];
          return nil;
    }];
}
@end
