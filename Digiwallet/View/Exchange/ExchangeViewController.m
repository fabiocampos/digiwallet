//
//  ExchangeViewController.m
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ExchangeViewController.h"
#import <UIKit/UIKit.h>
#import "BitcoinApi.h"
#import "BritaApi.h"
#import "CoinTableViewCell.h"
#import "AppDelegate.h"
#import "FSError.h"
#import "MoneyFormat.h"
@interface ExchangeViewController() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.coinTableView.dataSource = self;
    self.coinTableView.delegate = self;
    [NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self selector:@selector(animateAvailableAmount) userInfo:nil repeats:YES];
    [self animateAvailableAmount];
    [[self.viewModel executeGetBritaPriceSignal] subscribeNext:^(id  _Nullable x) {
        [self.coinTableView reloadData];
    }];
    [[self.viewModel executeGetBitcoinPriceSignal] subscribeNext:^(id  _Nullable x) {
        [self.coinTableView reloadData];
    }];

}

- (void)animateAvailableAmount {
    [UIView animateWithDuration:0.6 animations:^(void) {
        self.availableAmount.alpha = 0;
        self.availableAmountName.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^(void) {
            [self showUserCoin];
        }];
    }];
}

- (void)showUserCoin{
    CoinPrice *coin = [self.viewModel getDisplayableUserCoin];
    NSString *moneyMask = @"R$";
    self.availableAmount.text = [MoneyFormat formatMoney:coin.sellValue withMask:moneyMask];
    self.availableAmount.alpha = 1;
    self.availableAmountName.text = coin.name;
    self.availableAmountName.alpha = 1;
    [self.viewModel cycleUserCoin];
}

+(ExchangeViewModel *)createViewModel {
    BitcoinApi *bitcoinApi = [[BitcoinApi alloc] init];
    BritaApi *britaApi = [[BritaApi alloc] init];
    ExchangeService *exchangeService = [[ExchangeService alloc] initWithBitcoinApi:bitcoinApi andBritaApi:britaApi];
    ExchangeViewModel *viewModel = [[ExchangeViewModel alloc] initWithServices:exchangeService];
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    viewModel.currentUser = [appDelegate getCurrentUser];
    
    return viewModel;
}

#pragma TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

#pragma TableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoinData"];
    CoinPrice *coinPrice = [self.viewModel.coinPrices objectAtIndex:[indexPath row]];
    [cell initLayout:coinPrice];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.coinPrices count];
}
@end
