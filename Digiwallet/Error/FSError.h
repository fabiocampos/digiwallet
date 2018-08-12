//
//  FSError.h
//  Digiwallet
//
//  Created by Fabio Campos on 12/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DigiwalletError : NSUInteger {
    FSNotEnoughtMoney = 1000,
    FSBrokerNotAvailable = 1001
} DigiwalletError;

@interface FSError : NSObject
    FOUNDATION_EXPORT NSString *const FSDigiwalletDomain;
@end
