//
//  CoinTableViewCell.m
//  Digiwallet
//
//  Created by Fabio Campos on 10/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "CoinTableViewCell.h"
#import "MoneyFormat.h"
@implementation CoinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)initLayout:(CoinPrice*)coinPrice {
    self.name.text = coinPrice.name;
    NSString *moneyMask = @"R$";
    [self.buyValue setText:[MoneyFormat formatMoney:coinPrice.buyValue withMask:moneyMask]];
    [self.sellValue setText:[MoneyFormat formatMoney:coinPrice.sellValue withMask:moneyMask]];
    self.coinImage.image = [MoneyFormat getCoinImage:coinPrice];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
