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

@interface ExchangeViewController() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    

    self.coinTableView.dataSource = self;
    self.coinTableView.delegate = self;

    [[self.viewModel executeGetBritaPriceSignal] subscribeNext:^(id  _Nullable x) {
        [self.coinTableView reloadData];
        [[self.viewModel executeGetBitcoinPriceSignal] subscribeNext:^(id  _Nullable x) {
          [self.coinTableView reloadData];
        }];
    }];

    

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
    return 150;
}
#pragma TableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoinData"];
    [cell.buyValue setText:@"R$ 66,60"];
    [cell.sellValue setText:@"R$ 50,50"];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.coinPrices count];
}
@end
