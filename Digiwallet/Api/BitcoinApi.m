//
//  BitcoinApi.m
//  Digiwallet
//
//  Created by Fabio Campos on 08/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "BitcoinApi.h"

@implementation BitcoinApi

- (void)getBitcoinCotationWithSuccess:(void (^)(BitcoinPrice *bitCointPrice))success
                        failure:(void (^)(NSError *err))failure{
    NSURL *url = [[NSURL alloc] initWithString:@"https://www.mercadobitcoin.net/api/"];
    AFHTTPSessionManager *networkingManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    [networkingManager GET:@"BTC/ticker/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BitcoinPrice *bitcoinPrice = [[BitcoinPrice alloc] init];
        bitcoinPrice.buyValue = responseObject[@"ticker"][@"buy"];
        bitcoinPrice.sellValue = responseObject[@"ticker"][@"sell"];
        success(bitcoinPrice);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
          failure(error);
    }];
    
}

@end
