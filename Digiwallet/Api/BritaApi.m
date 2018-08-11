//
//  BritaApi.m
//  Digiwallet
//
//  Created by Fabio Campos on 11/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "BritaApi.h"

@interface BritaApi ()
@property (strong, nonatomic) AFHTTPSessionManager *networkingManager;
@end

@implementation BritaApi
NSString *const BRAZILIAN_CENTRAL_BANK_API = @"https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/";
NSString *const DAILY_COTATION_ENDPOINT = @"CotacaoDolarDia(dataCotacao=@dataCotacao)?%@%@%@";

- (instancetype)init{
    self = [super init];
    if (self ) {
          NSURL *url = [[NSURL alloc] initWithString:BRAZILIAN_CENTRAL_BANK_API];
        _networkingManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void)getBritaCotationWithSuccess:(void (^)(CoinPrice *britaPrice))success
                              failure:(void (^)(NSError *err))failure{
  
    NSDate *cotationDate = [self getCotationDate];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSString *cotationDateFormatted = [dateFormat stringFromDate:cotationDate];
   NSString *enpoint = [NSString stringWithFormat:DAILY_COTATION_ENDPOINT,@"%40dataCotacao=%27", cotationDateFormatted, @"%27&%24format=json"];
    //@Todo create a failover for holydays
    [self.networkingManager GET:enpoint parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != nil && [[responseObject objectForKey:@"value"] count] > 0){
            CoinPrice *britaPrice = [[CoinPrice alloc] init];
            britaPrice.buyValue = responseObject[@"value"][0][@"cotacaoCompra"];
            britaPrice.sellValue = responseObject[@"value"][0][@"cotacaoVenda"];
            britaPrice.type = kBrita;
            success(britaPrice);
            
        }else{
            NSLog(@"No price for this date: %@", cotationDateFormatted);
            failure([[NSError alloc] init]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        failure(error);
    }];
    
}

-(NSDate*) getCotationDate{
    NSDate *cotationDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger weekday = [calendar component:NSCalendarUnitWeekday
                                   fromDate:cotationDate];
    if(weekday == 1){
        [dateComponents setDay:-2];
        cotationDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:cotationDate options:0];
    }else if(weekday == 7){
        [dateComponents setDay:-1];
        cotationDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:cotationDate options:0];
    }
    return cotationDate;
}

@end
