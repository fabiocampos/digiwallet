//
//  CoinTableViewCell.h
//  Digiwallet
//
//  Created by Fabio Campos on 10/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoinPrice.h"
@interface CoinTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buyValue;
@property (weak, nonatomic) IBOutlet UILabel *sellValue;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *sellButton;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *coinImage;
- (void)initLayout:(CoinPrice*)coinPrice;
@end
