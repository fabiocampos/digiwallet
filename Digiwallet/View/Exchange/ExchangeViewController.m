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
#import "CoinTableViewCell.h"

@interface ExchangeViewController() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.coinTableView.dataSource = self;
    self.coinTableView.delegate = self;

}

+(ExchangeViewModel *)createViewModel {
    BitcoinApi *bitcoinApi = [[BitcoinApi alloc] init];
    ExchangeService *exchangeService = [[ExchangeService alloc] initWithApi:bitcoinApi];
    ExchangeViewModel *viewModel = [[ExchangeViewModel alloc] initWithServices:exchangeService];
    
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
    return 2;
}
@end
