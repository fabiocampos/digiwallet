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
#import "TradeViewController.h"
#import "TradeViewModel.h"

@interface ExchangeViewController() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.coinTableView.dataSource = self;
    self.coinTableView.delegate = self;
    self.title = @"Home";
    [NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self selector:@selector(animateAvailableAmount) userInfo:nil repeats:YES];
    [self animateAvailableAmount];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.viewModel.coinPrices = [[NSMutableArray alloc] init];
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
    NSString *moneyMask = [MoneyFormat getCoinMask:coin.type];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.viewModel.selectedCoin = [self.viewModel.coinPrices objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Trade" sender:self];
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

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Trade"])
    {
        TradeViewModel *tradeViewMode = [[TradeViewModel alloc] initWithServices:self.viewModel.exchangeService andUser:self.viewModel.currentUser toTrade:self.viewModel.selectedCoin];
        TradeViewController *viewController = segue.destinationViewController;
        viewController.viewModel = tradeViewMode;
    }
}
@end
