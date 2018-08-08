//
//  LoginService.h
//  Digiwallet
//
//  Created by Fabio Campos on 05/08/2018.
//  Copyright © 2018 green. All rights reserved.
//
#import <ReactiveObjC.h>
#import <Foundation/Foundation.h>

@interface LoginService : NSObject
- (RACSignal *) loginWithEmail:(NSString *)email andPassword:(NSString *)password;
@end
