//
//  ExchangeViewController.m
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ExchangeViewController.h"
#import <UIKit/UIKit.h>
#import "ExchangeViewModel.h"

@interface ExchangeViewController()
@property (weak, nonatomic) ExchangeViewModel *viewModel;
@end

@implementation ExchangeViewController
- (instancetype)initWithViewModel:(ExchangeViewModel *)viewModel {
    if (self ) {
        _viewModel = viewModel;
    }else{
        self = [super init];
        _viewModel = viewModel;
    }
    return self;
}
@end
