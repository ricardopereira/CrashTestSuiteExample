//
//  CrashTestSuiteExampleTests.m
//  CrashTestSuiteExampleTests
//
//  Created by Ricardo Pereira on 10/03/16.
//  Copyright © 2016 Ricardo Pereira. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CrashTestSuiteExampleTests : XCTestCase

@end

@implementation CrashTestSuiteExampleTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testFailure {
    XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];

    [self doSomethingAsync:false callback:^{
        NSAssert(false, @"Done");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)doSomethingAsync:(BOOL)performBlock callback:(void (^)())callback {
    __block CFRunLoopRef rl = CFRunLoopGetCurrent();

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://google.com/?q=crash"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (performBlock) {
            CFRunLoopPerformBlock(rl, kCFRunLoopDefaultMode, ^{
                callback();
            });
        }
        else {
            callback();
        }

        CFRunLoopWakeUp(rl);
    }] resume];
}

@end
