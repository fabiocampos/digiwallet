//
//  DigiwalletTests.m
//  DigiwalletTests
//
//  Created by Fabio Campos on 04/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ReactiveObjC.h>
#import "UserViewModel.h"
#import <OCMock/OCMock.h>
#import "User.h"

@interface UserViewModelTests : XCTestCase
@property UserViewModel *viewModel;
@property User *user;
@end

@implementation UserViewModelTests

- (void)setUp {
    [super setUp];
    id loginServiceMock = OCMClassMock([LoginService class]);
    self.user = [[User alloc] init];
    self.user.email = @"pepe@teste.com";
    self.user.balance = [[NSNumber alloc] initWithFloat:100000.00];
    RACSignal *userSignal = [RACSignal return:self.user];
    OCMStub([loginServiceMock loginWithEmail:@"pepe@teste.com" andPassword:@"senhaSegura"]).andReturn(userSignal);
    self.viewModel = [[UserViewModel alloc] initWithService:loginServiceMock];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLogin {
    self.viewModel.login = @"pepe@teste.com";
    self.viewModel.password = @"senhaSegura";
    
    RACCommand *command = [self.viewModel executeLogin];
    NSError *error;
    [[command execute:nil] asynchronouslyWaitUntilCompleted:&error];
    XCTAssertEqualObjects(self.viewModel.loggedInUser, self.user);
}


@end
