//
//  ReceiptTableViewCell.h
//  Digiwallet
//
//  Created by Fabio Campos on 13/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Operation.h"
@interface ReceiptTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *toCoinValue;
@property (weak, nonatomic) IBOutlet UILabel *toCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromCoinValue;
@property (weak, nonatomic) IBOutlet UILabel *operationDate;
@property  Operation *operation;
- (void)initLayout:(Operation*)operation;
@end
