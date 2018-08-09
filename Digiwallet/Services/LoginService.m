//
//  LoginService.m
//  Digiwallet
//
//  Created by Fabio Campos on 05/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "User.h"
#import "CryptoUtils.h"
#import "LoginService.h"
#import "BitcoinApi.h"

@implementation LoginService

- (RACSignal*)loginWithEmail:(NSString *)email andPassword:(NSString *)password{
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {

        User *user;
        user = [User findUser:email];
        if(user != nil && ![user.auth isEqualToString:[CryptoUtils toSha256:password]]){
            NSLog(@"Credenciais invalidas");
            user = nil;
            [subscriber sendError:[NSError alloc]];
            [subscriber sendCompleted];
            return nil;
        }else if(user == nil){
            user = [User createUser:email withPassword:password];
            NSLog(@"Usuario criado %@", user.email);
        }
        NSLog(@"Logado com sucesso %@", user.email);
        [subscriber sendNext:user];
        [subscriber sendCompleted];
        return nil;
    }];
}

@end
