//
//  ExchangeViewController.h
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeViewModel.h"
@interface ExchangeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *coinTableView;
@property (strong, nonatomic) ExchangeViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *availableAmount;
+(ExchangeViewModel *)createViewModel;
@end
