//
//  LoginViewController.m
//  Digiwallet
//
//  Created by Fabio Campos on 04/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "LoginViewController.h"
#import "ExchangeViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;
@property (weak, nonatomic) UserViewModel *viewModel;
@end

@implementation LoginViewController

- (instancetype)initWithViewModel:(UserViewModel *)viewModel {
    if (self ) {
        _viewModel = viewModel;
    }else{
        self = [super init];
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    self.errorMessage.alpha = 0;
    [self.loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.title = @"Digiwallet";    
}

- (void)bindViewModel {
    self.userNameTextField.text = self.viewModel.login;
    self.passwordTextField.text = self.viewModel.password;
    RAC(self.viewModel, login) = self.userNameTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    self.loginButton.rac_command = self.viewModel.executeLogin;
    RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) =
    self.viewModel.executeLogin.executing;
    [self.viewModel.executeLogin.executionSignals
     subscribeNext:^(RACSignal *loginSignal){

         [UIView animateWithDuration:0.6 animations:^(void) {
             self.errorMessage.alpha = 0;
         }];
         [self.userNameTextField resignFirstResponder];
         [self.passwordTextField resignFirstResponder];
     }];
    [[RACObserve(self.viewModel, error) ignore:nil] subscribeNext:^(NSError* error) {
        [UIView animateWithDuration:0.6 animations:^(void) {
            self.errorMessage.alpha = 1;
        }];
    }];
    
    [[RACObserve(self.viewModel, loggedInUser) ignore:nil] subscribeNext:^(User* user) {
        [self.loginButton setTitle:@"Sucesso" forState:UIControlStateNormal];
        [self performSegueWithIdentifier:@"Home" sender:self];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Home"])
    {
        UITabBarController *tabViewController = segue.destinationViewController;
        ExchangeViewController *viewController = [[tabViewController viewControllers] objectAtIndex:0];
        viewController.viewModel = [ExchangeViewController createViewModel];
    }
}

@end
