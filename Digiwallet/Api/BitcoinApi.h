//
//  BitcoinApi.h
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CoinPrice.h"


@interface BitcoinApi : NSObject
- (void)getBitcoinCotationWithSuccess:(void (^)(CoinPrice *bitcoinPrice))success
                        failure:(void (^)(NSError *err))failure;
@end
