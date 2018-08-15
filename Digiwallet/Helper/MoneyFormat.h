//
//  MoneyFormat.h
//  Digiwallet
//
//  Created by Fabio Campos on 12/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoinPrice.h"
#import <UIKit/UIKit.h>
@interface MoneyFormat : NSObject
+ (NSString*)formatMoney:(NSNumber*)moneyValue withMask:(NSString*)mask;
+ (NSString*)getCoinMaskByName:(NSString*)coinName;
+ (NSNumber*)truncateMoney:(NSNumber*)moneyValue;
+ (UIImage*)getCoinImage:(CoinPrice*)coinPrice;
+ (NSString*)getCoinMask:(CoinTypes)coinType;
+ (NSString*)getCoinName:(CoinTypes)coinType;
@end
