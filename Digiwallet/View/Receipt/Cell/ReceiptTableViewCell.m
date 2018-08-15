//
//  ReceiptTableViewCell.m
//  Digiwallet
//
//  Created by Fabio Campos on 13/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ReceiptTableViewCell.h"
#import "MoneyFormat.h"
@implementation ReceiptTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)initLayout:(Operation*)operation {
    NSString *fromMoneyMask = [MoneyFormat getCoinMaskByName:operation.fromCoin];
    NSString *toMoneyMask = [MoneyFormat getCoinMaskByName:operation.toCoin];
   
    [self.toCoinValue setText:[MoneyFormat formatMoney:operation.value withMask:toMoneyMask]];
    [self.toCoinLabel setText:operation.toCoin];
    [self.fromCoinValue setText:[MoneyFormat formatMoney:operation.usedValue withMask:fromMoneyMask]];
    [self.fromCoinLabel setText:operation.fromCoin];
 
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yyyy HH:mm:ss";
    [self.operationDate setText: [dateFormatter stringFromDate:operation.date]];
    
}
@end
