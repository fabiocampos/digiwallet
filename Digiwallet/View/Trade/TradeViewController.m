//
//  TradeViewController.m
//  Digiwallet
//
//  Created by Fabio Campos on 12/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "TradeViewController.h"
#import "MoneyFormat.h"
#import "MoneyTextField.h"
@interface TradeViewController() <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation TradeViewController
NSArray *_pickerData;
bool isWalletPickerOpen = false;
NSInteger selectedCoinRow = 0;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pickerData = @[@"Reais", @"Bitcoin", @"Britas"];
    self.walletCurrencyPicker.dataSource = self;
    self.walletCurrencyPicker.delegate = self;
    self.walletPickerHeightConstraint.constant = 0;
    [self.walletCurrencyPicker layoutIfNeeded];
    self.operationCoinValue.text = [MoneyFormat formatMoney:self.viewModel.coinToTrade.buyValue withMask:@"R$"];
    self.operationCoinName.text = _viewModel.coinToTrade.name;
    self.operationCoinBkg.image = [MoneyFormat getCoinImage:self.viewModel.coinToTrade];
    self.amountInputValue.delegate = _amountInputValue;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (row) {
        case 0:
            [self.walletCoinButton setTitle:@"Reais" forState:UIControlStateNormal];
            self.walletCoinValue.text = [MoneyFormat formatMoney:self.viewModel.currentUser.balance withMask:@"R$"];
            break;
        case 1:
            [self.walletCoinButton setTitle:@"Bitcoin" forState:UIControlStateNormal];
            self.walletCoinValue.text = [MoneyFormat formatMoney:self.viewModel.currentUser.bitcoinBalance withMask:@"R$"];
            break;
        case 2:
            [self.walletCoinButton setTitle:@"Britas" forState:UIControlStateNormal];
            self.walletCoinValue.text = [MoneyFormat formatMoney:self.viewModel.currentUser.britaBalance withMask:@"R$"];
            break;
        default:
            break;
    }
     selectedCoinRow = row;
     [self.view layoutIfNeeded];
}

- (IBAction)onOperationChanged:(id)sender {
    if([self.operationSegmentedControl selectedSegmentIndex] == 1){
        self.operationValueLabel.text = @"Valor compra:";
        [self.performOperationButton setTitle:@"Comprar" forState:UIControlStateNormal];
        self.operationCoinValue.text = [MoneyFormat formatMoney:self.viewModel.coinToTrade.buyValue withMask:@"R$"];
        
    }else{
        self.operationValueLabel.text = @"Valor venda:";
        [self.performOperationButton setTitle:@"Vender" forState:UIControlStateNormal];
        self.operationCoinValue.text = [MoneyFormat formatMoney:self.viewModel.coinToTrade.sellValue withMask:@"R$"];
    }
}

- (IBAction)onWalletCoinTouch:(id)sender {
    if(!isWalletPickerOpen){
        [self.walletCurrencyPicker setHidden:false];
        self.walletPickerHeightConstraint.constant = 162;
    }else{
        [self.walletCurrencyPicker setHidden:true];
        self.walletPickerHeightConstraint.constant = 0;
    }
    [UIView animateWithDuration:1.0 animations:^(void) {
        [self.view layoutIfNeeded];
        [self.view layoutSubviews];
    } completion:^(BOOL finished) {
        isWalletPickerOpen = !isWalletPickerOpen;
    }];
}
- (IBAction)onPerfomOperationTouch:(id)sender {

}

@end
