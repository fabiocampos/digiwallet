//
//  BitcoinApi.h
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BitcoinPrice.h"


@interface BitcoinApi : NSObject
- (void)getBitcoinCotationWithSuccess:(void (^)(BitcoinPrice *bitCointPrice))success
                        failure:(void (^)(NSError *err))failure;
@end
