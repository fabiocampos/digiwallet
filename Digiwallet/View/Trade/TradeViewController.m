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
#import "FSError.h"
@interface TradeViewController() <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation TradeViewController
bool isWalletPickerOpen = false;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.walletCurrencyPicker.dataSource = self;
    self.walletCurrencyPicker.delegate = self;
    self.walletPickerHeightConstraint.constant = 0;
    [self.walletCurrencyPicker layoutIfNeeded];
    self.operationCoinValue.text = [MoneyFormat formatMoney:self.viewModel.coinToTrade.buyValue withMask:@"R$"];
    self.operationCoinName.text = _viewModel.coinToTrade.name;
    self.operationCoinBkg.image = [MoneyFormat getCoinImage:self.viewModel.coinToTrade];
    self.amountInputValue.delegate = _amountInputValue;
    self.viewModel.tradeType = kBuy;
    self.viewModel.walletType = kBRL;
    [self pickerView:self.walletCurrencyPicker didSelectRow:0 inComponent:0];
    self.viewModel.selectedWallet = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.viewModel.availableCoins.count;
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.viewModel getTitleForRow:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.walletCoinButton setTitle:[self.viewModel getTitleForRow:row] forState:UIControlStateNormal];
    switch (row) {
        case 0:
            self.viewModel.walletType = kBRL;
            self.walletCoinValue.text = [MoneyFormat formatMoney:self.viewModel.currentUser.balance withMask:[MoneyFormat getCoinMask:kBRL]];
            break;
        case 1:
            self.viewModel.walletType = kBitcoin;
            self.walletCoinValue.text = [MoneyFormat formatMoney:self.viewModel.currentUser.bitcoinBalance withMask:[MoneyFormat getCoinMask:kBitcoin]];
            break;
        case 2:
            self.viewModel.walletType = kBrita;
            self.walletCoinValue.text = [MoneyFormat formatMoney:self.viewModel.currentUser.britaBalance withMask:[MoneyFormat getCoinMask:kBrita]];
            break;
        default:
            break;
    }
    self.viewModel.selectedWallet = row;
    [self.view layoutIfNeeded];
}

- (IBAction)onOperationChanged:(id)sender {
    if([self.operationSegmentedControl selectedSegmentIndex] == 1){
        self.viewModel.tradeType = kBuy;
        self.operationValueLabel.text = @"Valor compra:";
        [self.performOperationButton setTitle:@"Comprar" forState:UIControlStateNormal];
        self.operationCoinValue.text = [MoneyFormat formatMoney:self.viewModel.coinToTrade.buyValue withMask:[MoneyFormat getCoinMask:kBRL]];
        
    }else{
        self.viewModel.tradeType = kSell;
        self.operationValueLabel.text = @"Valor venda:";
        [self.performOperationButton setTitle:@"Vender" forState:UIControlStateNormal];
        self.operationCoinValue.text = [MoneyFormat formatMoney:self.viewModel.coinToTrade.sellValue withMask:[MoneyFormat getCoinMask:kBRL]];
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
    NSNumber *inputValue = [self.amountInputValue getInputValue];
    NSString *errorMessage = [self.viewModel validateAmount:inputValue];
    
    if(errorMessage != nil){
        [self showError:errorMessage];
        return;
    }
    
    [[self.viewModel performTradeOperation: inputValue] subscribeNext:^(id  _Nullable x) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sucesso" message:@"Transação realizada" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } error:^(NSError * _Nullable error) {
        NSString *errorMessage;
        if(error.code == FSNotEnoughtMoney){
            errorMessage = @"Saldo insuficiente";
        }else{
           errorMessage = @"Falha ao realizar operação";
        }
        [self showError:errorMessage];
    }];
}

- (IBAction)showError:(NSString*)errorMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Falha" message:errorMessage preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
