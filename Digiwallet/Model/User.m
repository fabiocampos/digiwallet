//
//  User.m
//  Digiwallet
//
//  Created by Fabio Campos on 05/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "User.h"
#import "CryptoUtils.h"

@implementation User

+ (User*)createUser:(NSString *)email withPassword:(NSString *)password{
    RLMRealm *realm = [RLMRealm defaultRealm];
    User *user = [[User alloc] init];
    user.auth = [CryptoUtils toSha256:password];
    user.email = email;
    user.balance = [[NSNumber alloc] initWithFloat:100000.00];
    
    [realm transactionWithBlock:^{
        [realm addObject:user];
    }];
    
    return user;
}

+ (User*)findUser:(NSString *)email{
    NSString *query = [NSString stringWithFormat:@"email == '%@'", email];
     User *user = [[User objectsWhere:query] firstObject];
    return user;
}

@end
