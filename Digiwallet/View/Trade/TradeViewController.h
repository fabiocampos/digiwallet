//
//  TradeViewController.h
//  Digiwallet
//
//  Created by Fabio Campos on 12/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeViewModel.h"

@interface TradeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *walletCurrencyPicker;
@property (weak, nonatomic) IBOutlet UIButton *walletCoinButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletPickerHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *walletCoinValue;
@property (weak, nonatomic) IBOutlet UITextField *amountInputValue;
@property (weak, nonatomic) IBOutlet UIButton *performOperationButton;
@property (weak, nonatomic) IBOutlet UILabel *operationValueLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *operationSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *operationCoinValue;
@property (weak, nonatomic) IBOutlet UILabel *operationCoinName;
@property (weak, nonatomic) IBOutlet UIImageView *operationCoinBkg;

@property (strong, nonatomic) TradeViewModel *viewModel;
@end
