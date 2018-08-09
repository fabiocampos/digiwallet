//
//  User.m
//  Digiwallet
//
//  Created by Fabio Campos on 04/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserViewModel.h"
#import "User.h"
@implementation UserViewModel

- (instancetype)initWithService:(LoginService *)loginService {
    self = [super init];
    if (self ) {
        [self initialize];
        _loginService = loginService;
    }
    
    RACSignal *validSearchSignal = [RACSignal
                                    combineLatest:@[RACObserve(self, login), RACObserve(self, password) ]
                                    reduce:^id(NSString *login, NSString *password) {
                                        return @(login.length > 3 && password.length > 3);
                                    }];
    
    self.executeLogin=
    [[RACCommand alloc] initWithEnabled:validSearchSignal
                            signalBlock:^RACSignal *(id input) {
                                return  [self executeLoginSignal];
                            }];
    return self;
}

- (RACSignal *)executeLoginSignal {
    return [[[self.loginService loginWithEmail:self.login andPassword:self.password]
             doNext:^(User *user) {
                 self.error = nil;
                 self.loggedInUser = user;
                 NSLog(@"Login %@", user.auth);
             }]
            doError:^(NSError * _Nonnull error) {
                 NSLog(@"Falha no login");
                  self.error = error;
             }] ;
}

- (void)initialize {
    self.login = @"";
    self.password = @"";
}

@end
