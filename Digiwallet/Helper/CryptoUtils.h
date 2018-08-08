//
//  CryptoUtils.h
//  Digiwallet
//
//  Created by Fabio Campos on 06/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CryptoUtils : NSObject
+ (NSString*)toSha256:(NSString*)input;
+ (NSString*)base64forData:(NSData*)theData;
@end
