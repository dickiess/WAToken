//
//  WATokenTests.m
//  WATokenTests
//
//  Created by dizhihao on 2018/5/23.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WALoginVC.h"

@interface WATokenTests : XCTestCase

@end

@implementation WATokenTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [[[WALoginVC alloc] init] testLogin];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
