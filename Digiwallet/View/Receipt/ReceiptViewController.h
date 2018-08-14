//
//  ReceiptViewController.h
//  Digiwallet
//
//  Created by Fabio Campos on 13/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiptViewModel.h"

@interface ReceiptViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *receiptTableView;
@property (weak, nonatomic) IBOutlet UILabel *brlAmount;
@property (weak, nonatomic) IBOutlet UILabel *bitCoinAmount;
@property (weak, nonatomic) IBOutlet UILabel *britalAmount;
@property (strong, nonatomic) ReceiptViewModel *viewModel;
+ (ReceiptViewModel *)createViewModel;
@end
