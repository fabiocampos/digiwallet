//
//  ExchangeServiceTests.m
//  DigiwalletTests
//
//  Created by Fabio Campos on 15/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "ExchangeService.h"
#import "BitcoinApi.h"
#import "BritaApi.h"

#import <XCTest/XCTest.h>
#import <ReactiveObjC.h>
#import "ExchangeViewModel.h"
#import <OCMock/OCMock.h>
#import "CoinPrice.h"
#import "User.h"
#import "Operation.h"
#import "FSError.h"

@interface ExchangeServiceTests : XCTestCase
@property ExchangeService *exchangeService;
@property User *user;
@property CoinPrice *brlCoin;
@property CoinPrice *britaCoin;
@property CoinPrice *bitCoin;
@end

@implementation ExchangeServiceTests

- (void)setUp {
    [super setUp];
    id bitcoinApi = OCMClassMock([BitcoinApi class]);
    id britaApi = OCMClassMock([BritaApi class]);
    self.exchangeService = [[ExchangeService alloc] initWithBitcoinApi:bitcoinApi andBritaApi:britaApi];
    self.user = [[User alloc] init];
    self.user.email = @"jarbas@teste.com";
    self.user.balance = [[NSNumber alloc] initWithDouble:100000.00];
    
    _brlCoin = [[CoinPrice alloc] init];
    _brlCoin.type = kBRL;
    _brlCoin.buyValue = [[NSDecimalNumber alloc] initWithInt:1];
    _brlCoin.sellValue = [[NSDecimalNumber alloc] initWithInt:1];
    _brlCoin.tradeAmount = [[NSDecimalNumber alloc] initWithInt:1];
    
    _britaCoin = [[CoinPrice alloc] init];
    _britaCoin.type = kBrita;
    _britaCoin.buyValue = [[NSDecimalNumber alloc] initWithDouble:3.90];
    _britaCoin.sellValue = [[NSDecimalNumber alloc] initWithDouble:3.85];
    _britaCoin.tradeAmount = [[NSDecimalNumber alloc] initWithInt:1];
    
    _bitCoin = [[CoinPrice alloc] init];
    _bitCoin.type = kBitcoin;
    _bitCoin.buyValue = [[NSDecimalNumber alloc] initWithDouble:20000.00];
    _bitCoin.sellValue = [[NSDecimalNumber alloc] initWithDouble:19800.25];
    _bitCoin.tradeAmount = [[NSDecimalNumber alloc] initWithInt:1];
    
    OCMStub([britaApi getBritaCotationWithSuccess:[OCMArg any] failure:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^passedBlock)(CoinPrice *coinPrice, NSError *error);
        [invocation getArgument: &passedBlock atIndex: 2];
        passedBlock(self.britaCoin, nil);
    });
    
    OCMStub([bitcoinApi getBitcoinCotationWithSuccess:[OCMArg any] failure:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^passedBlock)(CoinPrice *coinPrice, NSError *error);
        [invocation getArgument: &passedBlock atIndex: 2];
        passedBlock(self.bitCoin, nil);
    });
    
}

- (void)tearDown {
    [super tearDown];
    self.user.balance = [[NSNumber alloc] initWithDouble:100000.00];
    self.user.bitcoinBalance = [[NSNumber alloc] initWithDouble:0.00];
    self.user.britaBalance = [[NSNumber alloc] initWithDouble:0.00];
}

- (void)testTradeRealForBritaCoin {
    RACSignal *serviceSignal =  [self.exchangeService performTradeOperation:self.brlCoin forCoin:self.britaCoin ofType:kBuy forUser:self.user];
    [serviceSignal subscribeNext:^(Operation *operation) {
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.balance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:99996.10]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.britaBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:1.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.bitcoinBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:0.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.value doubleValue]], [[NSDecimalNumber alloc] initWithDouble:1.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.usedValue doubleValue]], [[NSDecimalNumber alloc] initWithDouble:3.9]);
        
        
    } error:^(NSError * _Nullable error) {
        XCTFail();
        
    }];
   
}

- (void)testTradeRealForBitCoin {
    RACSignal *serviceSignal =  [self.exchangeService performTradeOperation:self.brlCoin forCoin:self.bitCoin ofType:kBuy forUser:self.user];
    [serviceSignal subscribeNext:^(Operation *operation) {
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.balance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:80000.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.bitcoinBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:1.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.britaBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:0.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.value doubleValue]], [[NSDecimalNumber alloc] initWithDouble:1.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.usedValue doubleValue]], [[NSDecimalNumber alloc] initWithDouble:20000.00]);
        
        
    } error:^(NSError * _Nullable error) {
        XCTFail();
        
    }];
    
}

- (void)testTradeBritasForBitcoin {
    self.user.balance = [[NSNumber alloc] initWithDouble:94805.1948];
    self.user.bitcoinBalance = [[NSNumber alloc] initWithDouble:0.00];
    self.user.britaBalance = [[NSNumber alloc] initWithDouble:5194.8052];
    
    RACSignal *serviceSignal =  [self.exchangeService performTradeOperation:self.britaCoin forCoin:self.bitCoin ofType:kBuy forUser:self.user];
    [serviceSignal subscribeNext:^(Operation *operation) {
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.balance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:94805.1948]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.bitcoinBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:1.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.britaBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:0.000005194805248000001024]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.value doubleValue]], [[NSDecimalNumber alloc] initWithDouble:1.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.usedValue doubleValue]], [[NSDecimalNumber alloc] initWithDouble:5194.805194805193728]);
        
        
    } error:^(NSError * _Nullable error) {
        XCTFail();
        
    }];
    
}

- (void)testTradeBritasForBitcoinHavingNoFounds {
    self.user.balance = [[NSNumber alloc] initWithDouble:94871.7949];
    self.user.bitcoinBalance = [[NSNumber alloc] initWithDouble:0.00];
    self.user.britaBalance = [[NSNumber alloc] initWithDouble:5128.21];
    
    RACSignal *serviceSignal =  [self.exchangeService performTradeOperation:self.britaCoin forCoin:self.bitCoin ofType:kBuy forUser:self.user];
    [serviceSignal subscribeNext:^(Operation *operation) {
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.balance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:94871.7949]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.bitcoinBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:1.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.britaBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:0.01]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.value doubleValue]], [[NSDecimalNumber alloc] initWithDouble:1.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.usedValue doubleValue]], [[NSDecimalNumber alloc] initWithDouble:5128.2051]);
        
        
    } error:^(NSError * _Nullable error) {
        XCTAssertTrue(error.code == FSNotEnoughtMoney);
        
    }];
    
}

- (void)testTradeBritasForReal {
    self.user.balance = [[NSNumber alloc] initWithDouble:100000.00];
    self.user.bitcoinBalance = [[NSNumber alloc] initWithDouble:0.00];
    self.user.britaBalance = [[NSNumber alloc] initWithDouble:1];
    RACSignal *serviceSignal =  [self.exchangeService performTradeOperation:self.brlCoin forCoin:self.britaCoin ofType:kSell forUser:self.user];
    [serviceSignal subscribeNext:^(Operation *operation) {
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.balance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:100003.85]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.britaBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:0.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.bitcoinBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:0.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.value doubleValue]], [[NSDecimalNumber alloc] initWithDouble:3.85]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.usedValue doubleValue]], [[NSDecimalNumber alloc] initWithDouble:1]);
        
        
    } error:^(NSError * _Nullable error) {
        XCTFail();
        
    }];
    
}


- (void)testTradeBitcoinsForReal {
    self.user.balance = [[NSNumber alloc] initWithDouble:100000.00];
    self.user.bitcoinBalance = [[NSNumber alloc] initWithDouble:1.00];
    self.user.britaBalance = [[NSNumber alloc] initWithDouble:0];
    RACSignal *serviceSignal =  [self.exchangeService performTradeOperation:self.brlCoin forCoin:self.bitCoin ofType:kSell forUser:self.user];
    [serviceSignal subscribeNext:^(Operation *operation) {
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.balance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:119800.25]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.britaBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:0.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[self.user.bitcoinBalance doubleValue]], [[NSDecimalNumber alloc] initWithDouble:0.00]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.value doubleValue]], [[NSDecimalNumber alloc] initWithDouble:19800.25]);
        XCTAssertEqualObjects([[NSDecimalNumber alloc] initWithDouble:[operation.usedValue doubleValue]], [[NSDecimalNumber alloc] initWithDouble:1]);
        
        
    } error:^(NSError * _Nullable error) {
        XCTFail();
        
    }];
    
}



@end
