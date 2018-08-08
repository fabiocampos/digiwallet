//
//  LoginViewController.h
//  Digiwallet
//
//  Created by Fabio Campos on 04/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewModel.h"
@interface LoginViewController : UIViewController
- (instancetype)initWithViewModel:(UserViewModel *)viewModel;
@end
