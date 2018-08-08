//
//  User.h
//  Digiwallet
//
//  Created by Fabio Campos on 04/08/2018.
//  Copyright © 2018 green. All rights reserved.
//
#import <ReactiveObjC.h>
#import "User.h"
#import "LoginService.h"
@interface UserViewModel : NSObject

@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) NSString *login;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) RACCommand *executeLogin;
@property (strong, nonatomic) User *loggedInUser;
@property (strong, nonatomic) LoginService *loginService;
- (instancetype)initWithService:(LoginService *)loginService;
@end
