//
//  BritaApi.h
//  Digiwallet
//
//  Created by Fabio Campos on 11/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CoinPrice.h"

@interface BritaApi : NSObject
- (void)getBritaCotationWithSuccess:(void (^)(CoinPrice *britaPrice))success
                              failure:(void (^)(NSError *err))failure;
@end
