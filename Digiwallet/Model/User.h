//
//  User.h
//  Digiwallet
//
//  Created by Fabio Campos on 05/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>

@interface User : RLMObject
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *auth;
@property (strong, nonatomic) NSNumber<RLMDouble> *balance;
@property (strong, nonatomic) NSNumber<RLMDouble> *bitcoinBalance;
@property (strong, nonatomic) NSNumber<RLMDouble> *britaBalance;

+ (User*)createUser:(NSString *)email withPassword:(NSString *)password;
+ (User*)findUser:(NSString *)email;
@end
