//
//  ReceiptViewController.m
//  Digiwallet
//
//  Created by Fabio Campos on 13/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ReceiptViewController.h"
#import "ReceiptTableViewCell.h"
#import "AppDelegate.h"
#import "MoneyFormat.h"
@interface ReceiptViewController() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ReceiptViewController

+ (ReceiptViewModel *)createViewModel {
    ReceiptViewModel *viewModel = [[ReceiptViewModel alloc] init];
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    viewModel.currentUser = [appDelegate getCurrentUser];
    return viewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.receiptTableView.dataSource = self;
    self.receiptTableView.delegate = self;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self.viewModel getOperationReceipts] subscribeNext:^(id  _Nullable x) {
        [self.receiptTableView reloadData];
    } error:^(NSError * _Nullable error) {
        NSLog(@"Loading error: %@, %@", error, error.userInfo);
    }];
    self.brlAmount.text = [MoneyFormat formatMoney:self.viewModel.currentUser.balance withMask:[MoneyFormat getCoinMask:kBRL]];
    self.bitCoinAmount.text = [MoneyFormat formatMoney:self.viewModel.currentUser.bitcoinBalance withMask:[MoneyFormat getCoinMask:kBitcoin]];
    self.britalAmount.text = [MoneyFormat formatMoney:self.viewModel.currentUser.britaBalance withMask:[MoneyFormat getCoinMask:kBrita]];
}

#pragma TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma TableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ReceiptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiptCell"];
    Operation *operation = [self.viewModel.operations objectAtIndex:[indexPath row]];
    [cell initLayout:operation];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.operations count];
}


@end
