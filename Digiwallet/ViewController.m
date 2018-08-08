//
//  ViewController.m
//  Digiwallet
//
//  Created by Fabio Campos on 04/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    RACSignal *usernameSourceSignal =
    self.self.moneyTextField.rac_textSignal;
    
    RACSignal *filteredUsername = [usernameSourceSignal
                                   filter:^BOOL(id value) {
                                       NSString *text = value;
                                       return text.length > 3;
                                   }];
    
    [filteredUsername subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
//    [self.moneyTextField.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
